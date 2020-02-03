#import "MMELocationManager.h"
#import "MMETestStub.h"

@interface MMELocationManagerFake : MMETestStub <MMELocationManager>

@property (nonatomic, weak) id<MMELocationManagerDelegate> delegate;
@property (nonatomic, getter=isUpdatingLocation, readonly) BOOL updatingLocation;
@property (nonatomic, getter=isMetricsEnabledForInUsePermissions) BOOL metricsEnabledForInUsePermissions;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
