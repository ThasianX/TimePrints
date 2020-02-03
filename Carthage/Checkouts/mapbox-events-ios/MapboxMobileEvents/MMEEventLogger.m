#import "MMEEventLogger.h"
#import "MMEEvent.h"
#import "MMEEventLogReportViewController.h"
#import "MMEUINavigation.h"
#import "MMEDate.h"
#import <WebKit/WebKit.h>

@interface MMEEventLogger()

@property (nonatomic, copy) NSString *dateForDebugLogFile;
@property (nonatomic) dispatch_queue_t debugLogSerialQueue;
@property (nonatomic) NSDate *nextLogFileDate;
@property (nonatomic, getter=isTimeForNewLogFile) BOOL timeForNewLogFile;

@end

@implementation MMEEventLogger

+ (instancetype)sharedLogger {
    static MMEEventLogger *_sharedLogger;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedLogger = [[MMEEventLogger alloc] init];
    });
    
    return _sharedLogger;
}

+ (NSDateFormatter *)logFileDateFormatter {
    static NSDateFormatter *_logFileFormatter = nil;
    if (!_logFileFormatter) {
        _logFileFormatter = [[NSDateFormatter alloc] init];
        [_logFileFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
        [_logFileFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }

    return _logFileFormatter;
}

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        MMEDate* now = [MMEDate date];
        self.dateForDebugLogFile = [MMEEventLogger.logFileDateFormatter stringFromDate:now];
        self.nextLogFileDate = [now mme_startOfTomorrow];
    }
    return self;
}

- (void)logEvent:(MMEEvent *)event {
    if (self.isEnabled) {
        NSLog(@"%@", [NSString stringWithFormat:@"Mapbox Telemetry event %@", event]);
        
        [self writeEventToLocalDebugLog:event];
    }
}

#pragma mark - Write to Local File

- (void)pushDebugEventWithAttributes:(MMEMapboxEventAttributes *)attributes {
    MMEMutableMapboxEventAttributes *combinedAttributes = [MMEMutableMapboxEventAttributes dictionaryWithDictionary:attributes];
    [combinedAttributes setObject:[MMEDate.iso8601DateFormatter stringFromDate:[NSDate date]] forKey:@"created"];
    MMEEvent *debugEvent = [MMEEvent debugEventWithAttributes:combinedAttributes];
    [MMEEventLogger.sharedLogger logEvent:debugEvent];
}

- (BOOL)timeForNewLogFile {
    return [[NSDate date] timeIntervalSinceDate:self.nextLogFileDate] > 0;
}

- (void)writeEventToLocalDebugLog:(MMEEvent *)event {
    MMEDate* now = [MMEDate date];

    if (!self.isEnabled) {
        return;
    }
    
    if (self.timeForNewLogFile) {
        self.dateForDebugLogFile = [MMEEventLogger.logFileDateFormatter stringFromDate:now];
        self.nextLogFileDate = [now mme_startOfTomorrow];
    }
    
    if (!self.debugLogSerialQueue) {
        NSString *uniqueID = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        self.debugLogSerialQueue = dispatch_queue_create([[NSString stringWithFormat:@"%@.%@.events.debugLog", appBundleID, uniqueID] UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
    NSDictionary *eventDict = @{event.name: event.attributes};
    
    dispatch_async(self.debugLogSerialQueue, ^{
        if ([NSJSONSerialization isValidJSONObject:eventDict]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:eventDict options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonString = [jsonString stringByAppendingString:@",\n"];
            
            NSString *logFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"telemetry_log-%@.json", self.dateForDebugLogFile]];
            
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            if ([fileManager fileExistsAtPath:logFilePath]) {
                NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
                [fileHandle seekToEndOfFile];
                [fileHandle writeData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
            } else {
                [fileManager createFileAtPath:logFilePath contents:[jsonString dataUsingEncoding:NSUTF8StringEncoding] attributes:@{ NSFileProtectionKey: NSFileProtectionCompleteUntilFirstUserAuthentication }];
            }
        }
    });
}

#pragma mark - HTML Generation

- (void)readAndDisplayLogFileFromDate:(NSDate *)logDate {
    MMEEventLogReportViewController *logVC = [[MMEEventLogReportViewController alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd";
    
    NSString *dateString = [dateFormatter stringFromDate:logDate];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *path = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"telemetry_log-%@.json", dateString]];
    
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if (jsonString) {
        NSString *contents = [NSString stringWithFormat:@"[%@]", jsonString];
        NSString *dataString = [self parseJSONFromFileContents:contents];
        
        [[MMEUINavigation topViewController] presentViewController:logVC animated:YES completion:nil];
        [logVC displayHTMLFromRowsWithDataString:dataString];
    } else {
        if (self.isEnabled) {
            NSLog(@"error reading file: %@", jsonString);
        }
    }
}

- (NSString *)parseJSONFromFileContents:(NSString *)contents {
    NSMutableArray *timelineDataArray = [[NSMutableArray alloc] init];
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:[contents dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    if (JSON) {
        for (NSDictionary *dictionary in JSON) {
            NSDictionary *eventDict = [dictionary valueForKeyPath:@"debug"];
            
            if (eventDict) {
                if ([eventDict valueForKey:@"created"]) {
                    NSDate *date = [MMEDate.iso8601DateFormatter dateFromString:[eventDict valueForKey:@"created"]];
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                                    NSCalendarUnitYear |
                                                    NSCalendarUnitMonth |
                                                    NSCalendarUnitDay |
                                                    NSCalendarUnitHour |
                                                    NSCalendarUnitMinute |
                                                    NSCalendarUnitSecond fromDate:date];
                    
                    NSDictionary *debugDict = [NSDictionary dictionaryWithObject:[eventDict valueForKey:@"debug.type"] forKey:@"v"];
                    NSDictionary *instanceDict = [NSDictionary dictionaryWithObject:[eventDict valueForKey:@"instance"] forKey:@"v"];
                    NSString *htmlTooltip = [NSString stringWithFormat:@"<b>Description:</b> %@<br><b>Instance:</b> %@",[eventDict valueForKey:@"debug.description"],[eventDict valueForKey:@"instance"]];
                    NSDictionary *tooltipDict = [NSDictionary dictionaryWithObject:htmlTooltip forKey:@"v"];
                    NSDictionary *dateDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Date(%ld, %ld, %ld, %ld, %ld, %ld)", (long)components.year, (long)components.month, (long)components.day, (long)components.hour, (long)components.minute, (long)components.second] forKey:@"v"];
                    NSArray *array = @[debugDict, instanceDict, tooltipDict, dateDict, dateDict];
                    NSDictionary *wrapDict = [NSDictionary dictionaryWithObject:array forKey:@"c"];
                    
                    [timelineDataArray addObject:wrapDict];
                }
            }
        }
        if ([NSJSONSerialization isValidJSONObject:timelineDataArray]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:timelineDataArray options:NSJSONWritingPrettyPrinted error:nil];
            if (jsonData) {
                return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
        } else {
            if (self.isEnabled) {
                NSLog(@"Invalid JSON Object: %@", timelineDataArray);
            }
        }
    } else {
        if (self.isEnabled) {
            NSLog(@"error parsing JSON: %@", JSON);
        }
    }
    return nil;
}

@end

