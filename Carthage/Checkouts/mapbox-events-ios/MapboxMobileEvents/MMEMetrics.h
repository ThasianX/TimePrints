#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@class MMEDate;

@interface MMEMetrics : NSObject

@property (nonatomic) NSUInteger requests;
@property (nonatomic, readonly) NSUInteger totalBytesSent;
@property (nonatomic) NSUInteger cellBytesSent;
@property (nonatomic) NSUInteger wifiBytesSent;
@property (nonatomic, readonly) NSUInteger totalBytesReceived;
@property (nonatomic) NSUInteger cellBytesReceived;
@property (nonatomic) NSUInteger wifiBytesReceived;
@property (nonatomic) NSUInteger appWakeups;
@property (nonatomic) NSUInteger eventCountFailed;
@property (nonatomic) NSUInteger eventCountTotal;
@property (nonatomic) NSUInteger eventCountMax;
@property (nonatomic) CLLocationDegrees deviceLat;
@property (nonatomic) CLLocationDegrees deviceLon;
@property (nonatomic) MMEDate *recordingStarted;
@property (nonatomic) NSString *dateUTCString;
@property (nonatomic) NSDictionary *configResponseDict;
@property (nonatomic) NSMutableDictionary *eventCountPerType;
@property (nonatomic) NSMutableDictionary *failedRequestsDict;

@end

NS_ASSUME_NONNULL_END
