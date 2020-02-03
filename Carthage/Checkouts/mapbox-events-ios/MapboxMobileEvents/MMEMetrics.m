#import "MMEMetrics.h"
#import "MMEDate.h"

@implementation MMEMetrics

- (instancetype)init {
    self = [super init];
    if (self) {
        _failedRequestsDict = [[NSMutableDictionary alloc] init];
        _eventCountPerType = [[NSMutableDictionary alloc] init];
        _recordingStarted = [MMEDate date];
        _cellBytesSent = 0;
        _wifiBytesSent = 0;
        _cellBytesReceived = 0;
        _wifiBytesReceived = 0;
        _eventCountFailed = 0;
        _eventCountTotal = 0;
        _eventCountMax = 0;
        _appWakeups = 0;
        _deviceLat = 0;
        _deviceLon = 0;
        _requests = 0;
    }
    return self;
}

- (NSUInteger) totalBytesSent { return _wifiBytesSent + _cellBytesSent; }
- (NSUInteger) totalBytesReceived { return _wifiBytesReceived + _cellBytesReceived; }

@end
