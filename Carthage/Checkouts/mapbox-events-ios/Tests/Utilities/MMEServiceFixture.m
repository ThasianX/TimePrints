#import "MMEServiceFixture.h"

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

NSUInteger const MMEFixtureDefaultPort = 8080;

static NSUInteger MMEServiceFixturePort = MMEFixtureDefaultPort;
static NSURL *MMEServiceFixtureURL;

NS_ASSUME_NONNULL_BEGIN

NSErrorDomain const MMEServiceFixtureErrorDomain = @"MMEServiceFixtureErrorDomain";
NSTimeInterval const MME1sTimeout = 1.0;
NSTimeInterval const MME10sTimeout = 10.0;
NSTimeInterval const MME100sTimeout = 100.0;
NSUInteger const MMEPrivledgedPort = 1024;

@interface MMEServiceFixture ()
@property(nonatomic) NSLock *serviceLock;
@property(nonatomic) NSString *fixtureFile;
@property(nonatomic) NSFileHandle *listeningHandle;
@property(nonatomic) NSError *serviceError;
@property(nonatomic, nullable) id serverSocket;

@end

// MARK: -

@implementation MMEServiceFixture

+ (NSUInteger)servicePort {
    return MMEServiceFixturePort;
}

+ (void)setServicePort:(NSUInteger)newPort {
    if (newPort > MMEPrivledgedPort) {
        MMEServiceFixturePort = newPort;
        MMEServiceFixtureURL = nil;
    }
    else NSLog(@"ERROR: %@ can't set privileged service port: %lu", NSStringFromClass(self), (unsigned long)newPort);
}

+ (NSURL *)serviceURL {
    if (!MMEServiceFixtureURL) {
        MMEServiceFixtureURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%lu/", (unsigned long)MMEServiceFixturePort]];
    }
    return MMEServiceFixtureURL;
}

// MARK: - MMEServiceFiture Factory Methods

+ (MMEServiceFixture *)serviceFixtureWithFile:(NSString *)fixtureFile {
    return [self.alloc initWithFile:fixtureFile];
}

+ (MMEServiceFixture *)serviceFixtureWithResource:(NSString *)fixtureName {
    NSString *fixtureFile = [NSBundle.mainBundle pathForResource:fixtureName ofType:@"json"];
    return [self serviceFixtureWithFile:fixtureFile];
}

// MARK: - MMEServiceFixture

- (instancetype)initWithFile:(NSString *)fixtureFile {
    if ((self = super.init)) {
        self.fixtureFile = fixtureFile;
        self.serviceLock = NSLock.new;
        [self startServer];
    }
    
    return self;
}

- (void)cleanupSocket {
    if (self.serverSocket) {
        CFSocketInvalidate((CFSocketRef)self.serverSocket);
        self.serverSocket = nil;
    }
}

- (BOOL)waitForConnectionWithTimeout:(NSTimeInterval)timeout error:(NSError **)error {
    BOOL success = NO;
    NSTimeInterval quantum = 0.1; // how long we wait for each lock check
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout];

    if (self.serviceError && error) { // if there was an error setting up, report it and exit
        *error = self.serviceError;
        goto exit;
    }

    NSLog(@"%@ waiting for connection with timeout: %1.2fs", NSStringFromClass(self.class), timeout);

    while (!(success = self.serviceLock.tryLock)) { // as long as we can't get the lock
        NSDate *wakeup = [NSDate dateWithTimeIntervalSinceNow:quantum];
        [NSRunLoop.currentRunLoop runUntilDate:wakeup]; // run the current run loop
     
        if (timeoutDate.timeIntervalSinceNow < 0) { // until we hit the timeout
            break;
        }
    }

    if (self.serviceError && error) {
        *error = self.serviceError;
        success = NO; // we got the lock, but we have an error to report
    }
exit:
    [self cleanupSocket];
    return success;
}

// MARK: -

- (void)startServer {
    CFDataRef addressData = nil;
    [self.serviceLock lock];
    CFSocketRef serverSocketRef = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, 0, NULL, NULL);
    self.serverSocket = CFBridgingRelease(serverSocketRef);
    if (!self.serverSocket) {
        self.serviceError = [NSError errorWithDomain:MMEServiceFixtureErrorDomain code:MMEServiceFixtureSocketCreateError userInfo:@{
            NSLocalizedDescriptionKey:@"Unable to create socket."
        }];
        goto exit;
    }

    int reuse = true;
    int fileDescriptor = CFSocketGetNative((CFSocketRef)self.serverSocket);
    if (setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEADDR, (void *)&reuse, sizeof(int)) != noErr) {
        self.serviceError = [NSError errorWithDomain:MMEServiceFixtureErrorDomain code:MMEServiceFixtureSocketOptionsError userInfo:@{
            NSLocalizedDescriptionKey:@"Unable to set SO_REUSEADDR option"
        }];
        goto exit;
    }
    
    if (setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEPORT, (void *)&reuse, sizeof(int)) != noErr) {
        self.serviceError = [NSError errorWithDomain:MMEServiceFixtureErrorDomain code:MMEServiceFixtureSocketOptionsError userInfo:@{
            NSLocalizedDescriptionKey:@"Unable to set SO_REUSEPORT option"
        }];
        goto exit;
    }
    
    struct sockaddr_in address;
    memset(&address, 0, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    address.sin_port = htons(MMEServiceFixture.servicePort);
    addressData = CFDataCreate(kCFAllocatorDefault, (const UInt8 *)&address, sizeof(address));
        
    if (CFSocketSetAddress((CFSocketRef)self.serverSocket, addressData) != kCFSocketSuccess) {
        self.serviceError = [NSError errorWithDomain:MMEServiceFixtureErrorDomain code:MMEServiceFixtureSocketBindError userInfo:@{
            NSLocalizedDescriptionKey:@"Unable to bind socket to address"
        }];
        goto exit;
    }

    self.listeningHandle = [NSFileHandle.alloc initWithFileDescriptor:fileDescriptor closeOnDealloc:YES];

    [NSNotificationCenter.defaultCenter
        addObserver:self
        selector:@selector(receiveIncomingConnectionNotification:)
        name:NSFileHandleConnectionAcceptedNotification
        object:nil];
    [self.listeningHandle acceptConnectionInBackgroundAndNotify];
    
    NSLog(@"%@ listening at %@ with %@", NSStringFromClass(self.class), MMEServiceFixture.serviceURL, self.fixtureFile.lastPathComponent);
    
exit:
    if (self.serviceError) { // log the error and cleanup any socket
        NSLog(@"%@ ERROR starting service fixture: %@", NSStringFromClass(self.class), self.serviceError);
        [self cleanupSocket];
    }

    if (addressData) {
        CFRelease(addressData);
    }
}

// MARK: - NSNotifications

- (void)receiveIncomingConnectionNotification:(NSNotification *)notification {
    NSFileHandle* requestHandle = notification.userInfo[NSFileHandleNotificationFileHandleItem];
    if (requestHandle) {
        NSError *requestError = nil;
        NSMutableString *requestString = [NSMutableString string];
        NSData *read = requestHandle.availableData;
        while (read.length > 0) {
            NSString *readString = [NSString.alloc initWithData:read encoding:NSUTF8StringEncoding];
            [requestString appendString:readString];
            // look for the end of the HTTP 1.1+ request (the handle won't close while the TCP socket is open)
            if ([requestString rangeOfString:@"\r\n\r\n" options:NSBackwardsSearch].location != NSNotFound) {
                break; // while
            }
            [requestHandle seekToFileOffset:read.length];
            read = requestHandle.availableData;
        }
        
        if (requestString.length > 0) {
            NSLog(@"%@ request:\n%@", NSStringFromClass(self.class), requestString);
        }
        else if (requestError) {
            self.serviceError = requestError;
        }
        
        NSData *responseData = [NSData dataWithContentsOfFile:self.fixtureFile];
        [requestHandle writeData:responseData];
        [requestHandle closeFile];
    }
    
    [self.listeningHandle closeFile];
    [self.serviceLock unlock];
}

@end

NS_ASSUME_NONNULL_END
