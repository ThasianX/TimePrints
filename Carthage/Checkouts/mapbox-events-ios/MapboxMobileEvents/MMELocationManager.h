#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MMELocationManagerDelegate;

@protocol MMELocationManager <NSObject>

@property (nonatomic, weak) id<MMELocationManagerDelegate> delegate;
@property (nonatomic, getter=isUpdatingLocation, readonly) BOOL updatingLocation;
@property (nonatomic, getter=isMetricsEnabledForInUsePermissions) BOOL metricsEnabledForInUsePermissions;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end

// MARK: -

extern const CLLocationDistance MMELocationManagerDistanceFilter;
extern const CLLocationDistance MMELocationManagerHibernationRadius;
extern NSString * const MMELocationManagerRegionIdentifier;

@interface MMELocationManager : NSObject <MMELocationManager>

@property (nonatomic, weak) id<MMELocationManagerDelegate> delegate;
@property (nonatomic, getter=isUpdatingLocation, readonly) BOOL updatingLocation;
@property (nonatomic, getter=isMetricsEnabledForInUsePermissions) BOOL metricsEnabledForInUsePermissions;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end

// MARK: -

@protocol MMELocationManagerDelegate <NSObject>

@optional

- (void)locationManager:(MMELocationManager *)locationManager didUpdateLocations:(NSArray *)locations;
- (void)locationManagerDidStartLocationUpdates:(MMELocationManager *)locationManager;
- (void)locationManagerBackgroundLocationUpdatesDidTimeout:(MMELocationManager *)locationManager;
- (void)locationManagerBackgroundLocationUpdatesDidAutomaticallyPause:(MMELocationManager *)locationManager;
- (void)locationManagerDidStopLocationUpdates:(MMELocationManager *)locationManager;
- (void)locationManager:(MMELocationManager *)locationManager didVisit:(CLVisit *)visit;

@end
