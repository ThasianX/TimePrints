#import <Cedar/Cedar.h>
#import <CoreLocation/CoreLocation.h>

#import "MMELocationManager.h"
#import "MMEDependencyManager.h"
#import "MMEUIApplicationWrapper.h"

#import "NSUserDefaults+MMEConfiguration.h"
#import "NSUserDefaults+MMEConfiguration_Private.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface MMELocationManager (Spec) <CLLocationManagerDelegate>

@property (nonatomic, getter=isUpdatingLocation, readwrite) BOOL updatingLocation;
@property (nonatomic) NSTimer *backgroundLocationServiceTimeoutTimer;
@property (nonatomic) NSDate *backgroundLocationServiceTimeoutAllowedDate;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) id<MMEUIApplicationWrapper> application;

- (void)timeoutAllowedCheck;
- (void)stopMonitoringRegions;

@end

SPEC_BEGIN(MMELocationManagerSpec)

describe(@"MMELocationManager", ^{
    
    __block MMELocationManager *locationManager;
    __block CLLocationManager *locationManagerInstance;
    
    beforeEach(^{
        locationManagerInstance = [[CLLocationManager alloc] init];
        spy_on(locationManagerInstance);
        // Even with the stub on UIBackgroundModes in test setup below, it is not safe to actually call `setAllowsBackgroundLocationUpdates:` in tests
        locationManagerInstance stub_method(@selector(setAllowsBackgroundLocationUpdates:)).and_do(^(NSInvocation *) { return; /* Do nothing */ });
        spy_on([MMEDependencyManager sharedManager]);
        [MMEDependencyManager sharedManager] stub_method(@selector(locationManagerInstance)).and_return(locationManagerInstance);
    });
    
    describe(@"- metricsEnabledForInUsePermissions", ^{
        
        context(@"when the host app has when in use permissions", ^{
            beforeEach(^{
                spy_on([CLLocationManager class]);
                [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusAuthorizedWhenInUse);
            });
            
            context(@"when the host application has background capability", ^{
                beforeEach(^{
                    spy_on([NSBundle mainBundle]);
                    [NSBundle mainBundle] stub_method(@selector(objectForInfoDictionaryKey:)).with(@"UIBackgroundModes").and_return(@[@"location"]);
                    
                    locationManager = [[MMELocationManager alloc] init];
                });
                
                it(@"allows the value to be set after startUpdatingLocation is called", ^{
                    [locationManager startUpdatingLocation];
                    
                    locationManager.metricsEnabledForInUsePermissions = YES;
                    locationManager.locationManager should have_received(@selector(setAllowsBackgroundLocationUpdates:)).with(YES);
                    
                    locationManager.metricsEnabledForInUsePermissions = NO;
                    locationManager.locationManager should have_received(@selector(setAllowsBackgroundLocationUpdates:)).with(NO);
                });
            });
            
            context(@"when the host application does NOT have background capability", ^{
                beforeEach(^{
                    spy_on([NSBundle mainBundle]);
                    [NSBundle mainBundle] stub_method(@selector(objectForInfoDictionaryKey:)).with(@"UIBackgroundModes").and_return(@[]);
                    
                    locationManager = [[MMELocationManager alloc] init];
                });
                
                it(@"guards against the value being set after startUpdatingLocation is called", ^{
                    [locationManager startUpdatingLocation];
                    
                    locationManager.metricsEnabledForInUsePermissions = YES;
                    locationManager.locationManager should_not have_received(@selector(setAllowsBackgroundLocationUpdates:));
                });
            });
            
        });
    });
    
    describe(@"- startUpdatingLocation", ^{
        
        context(@"when the host app has is denied location permissions", ^{
            beforeEach(^{
                spy_on([CLLocationManager class]);
                [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusDenied);
                
                locationManager = [[MMELocationManager alloc] init];
                [locationManager startUpdatingLocation];
            });
            
            it(@"then the location manager should NOT consider itself to be updating", ^{
                locationManager.isUpdatingLocation should be_falsy;
            });
        });
        
        context(@"when the host app has background capability and always permissions", ^{
            beforeEach(^{
                spy_on([NSBundle mainBundle]);
                [NSBundle mainBundle] stub_method(@selector(objectForInfoDictionaryKey:)).with(@"UIBackgroundModes").and_return(@[@"location"]);
                
                spy_on([CLLocationManager class]);
                [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusAuthorizedAlways);
                
                locationManager = [[MMELocationManager alloc] init];
                locationManager.delegate = nice_fake_for(@protocol(MMELocationManagerDelegate));
                locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
                
                [locationManager startUpdatingLocation];
            });
            
            it(@"sets itself of the delegate of the location manager", ^{
                locationManager.locationManager.delegate should equal(locationManager);
            });
            
            it(@"sets the desired accuracy correctly", ^{
                locationManager.locationManager.desiredAccuracy should equal(kCLLocationAccuracyThreeKilometers);
            });
            
            it(@"sets the distance filter correctly", ^{
                locationManager.locationManager.distanceFilter should equal(MMELocationManagerDistanceFilter);
            });
            
            it(@"calls the location manager wrapper's startMonitoringSignificantLocationChanges method", ^{
                locationManager.locationManager should have_received(@selector(startMonitoringSignificantLocationChanges));
            });
            
            it(@"starts the background timer", ^{
                locationManager.backgroundLocationServiceTimeoutTimer should_not be_nil;
            });
            
            it(@"starts updating location", ^{
                locationManager.isUpdatingLocation should be_truthy;
            });
            
            it(@"tells the location manager wrapper to allow background location updates", ^{
                locationManager.locationManager should have_received(@selector(setAllowsBackgroundLocationUpdates:)).with(YES);
            });
            
            it(@"tells the location manager wrapper to start updating location", ^{
                locationManager.locationManager should have_received(@selector(startUpdatingLocation));
            });
            
            it(@"tells the location manager to notify the delegate that it started location updates", ^{
                locationManager.delegate should have_received(@selector(locationManagerDidStartLocationUpdates:)).with(locationManager);
            });
        });
        
        context(@"when the host app has NO background capability and always permissions", ^{
            
            beforeEach(^{
                spy_on([NSBundle mainBundle]);
                [NSBundle mainBundle] stub_method(@selector(objectForInfoDictionaryKey:)).with(@"UIBackgroundModes").and_return(@[]);
                
                spy_on([CLLocationManager class]);
                [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusAuthorizedAlways);
                
                locationManager = [[MMELocationManager alloc] init];
                locationManager.delegate = nice_fake_for(@protocol(MMELocationManagerDelegate));
                locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
                
                [locationManager startUpdatingLocation];
            });
            
            it(@"should not tell location manager to startMonitoringSignificantLocationChanges", ^{
                locationManagerInstance should_not have_received(@selector(startMonitoringSignificantLocationChanges));
            });
            
            it(@"then background timer should not be started", ^{
                locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
            });
            
            it(@"should not tell location manager to allowsBackgroundLocationUpdates", ^{
                locationManager.locationManager.allowsBackgroundLocationUpdates should be_falsy;
            });
            
            it(@"tell location manager to startUpdatingLocation", ^{
                locationManager.locationManager should have_received(@selector(startUpdatingLocation));
            });
            
            it(@"checks that location manager considers itself to be updating location", ^{
                locationManager.isUpdatingLocation should be_truthy;
            });
            
            it(@"tells the location manager to notify it's delegate that it started location updates", ^{
                locationManager.delegate should have_received(@selector(locationManagerDidStartLocationUpdates:)).with(locationManager);
            });
            
            context(@"when authorization status changes to when in use", ^{
                beforeEach(^{
                    [locationManager locationManager:locationManagerInstance didChangeAuthorizationStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
                });
                
                it(@"then the location manager should consider itself to be updating", ^{
                    locationManager.isUpdatingLocation should be_truthy;
                });
            });
        });
        
        context(@"when the host app has has NO background capability when in use permissions", ^{
            beforeEach(^{
                spy_on([NSBundle mainBundle]);
                [NSBundle mainBundle] stub_method(@selector(objectForInfoDictionaryKey:)).with(@"UIBackgroundModes").and_return(@[]);
                
                spy_on([CLLocationManager class]);
                [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusAuthorizedWhenInUse);
                
                locationManager = [[MMELocationManager alloc] init];
                locationManager.delegate = nice_fake_for(@protocol(MMELocationManagerDelegate));
                locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
                locationManager.metricsEnabledForInUsePermissions = YES;
                
                [locationManager startUpdatingLocation];
            });
            
            it(@"should not tell location manager to startMonitoringSignificantLocationChanges", ^{
                locationManager.locationManager should_not have_received(@selector(startMonitoringSignificantLocationChanges));
            });
            
            it(@"then background timer should not be started", ^{
                locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
            });
            
            it(@"should not tell location manager to allowsBackgroundLocationUpdates", ^{
                locationManager.locationManager should_not have_received(@selector(setAllowsBackgroundLocationUpdates:));
                locationManager.locationManager.allowsBackgroundLocationUpdates should be_falsy;
            });
            
            it(@"tell location manager to startUpdatingLocation", ^{
                locationManager.locationManager should have_received(@selector(startUpdatingLocation));
            });
            
            it(@"checks that location manager considers itself to be updating location", ^{
                locationManager.isUpdatingLocation should be_truthy;
            });
            
            it(@"tells the location manager to notify it's delegate that it started location updates", ^{
                locationManager.delegate should have_received(@selector(locationManagerDidStartLocationUpdates:)).with(locationManager);
            });
            
            context(@"when authorization status changed to kCLAuthorizationStatusAuthorizedAlways", ^{
                beforeEach(^{
                    [locationManager locationManager:locationManagerInstance didChangeAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
                });
                
                it(@"then the location manager should consider itself to be updating", ^{
                    locationManager.isUpdatingLocation should be_truthy;
                });
            });
        });
    });
    
    describe(@"- stopUpdatingLocation", ^{
        
        beforeEach(^{
            spy_on([CLLocationManager class]);
            [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusAuthorizedAlways);
            
            locationManager = [[MMELocationManager alloc] init];
            locationManager.delegate = nice_fake_for(@protocol(MMELocationManagerDelegate));
            locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
            
            // Call startUpdatingLocation first since a useful test of stopUpdatingLocation requests `start` to be called previously
            [locationManager startUpdatingLocation];
            
            [locationManager stopUpdatingLocation];
        });
        
        it(@"tells location manager to stop updating location", ^{
            locationManager.locationManager should be_nil;
        });
        
        it(@"tells the location manager to stopMonitoringSignificantLocationChanges", ^{
            locationManager.delegate should have_received(@selector(locationManagerDidStopLocationUpdates:));
        });
        
    });
    
    describe(@"- timeoutAllowedCheck", ^{
        
        context(@"when the host app is in the background, has always location permissions, and after startUpdatingLocation has been called", ^{
            beforeEach(^{
                spy_on([CLLocationManager class]);
                [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusAuthorizedAlways);
                
                locationManager = [[MMELocationManager alloc] init];
                locationManager.delegate = nice_fake_for(@protocol(MMELocationManagerDelegate));
                
                spy_on(locationManager.application);
                locationManager.application stub_method(@selector(applicationState)).and_return(UIApplicationStateBackground);
                
                [locationManager startUpdatingLocation];
            });
            
            context(@"when timeoutAllowedCheck with allowed date set to now is called", ^{
                beforeEach(^{
                    locationManager.backgroundLocationServiceTimeoutAllowedDate = [NSDate date];
                    [locationManager timeoutAllowedCheck];
                });
                
                it(@"tells location manager to stop updating location", ^{
                    locationManager.locationManager should have_received(@selector(stopUpdatingLocation));
                });
                
                it(@"should reset timeout", ^{
                    locationManager.backgroundLocationServiceTimeoutAllowedDate should be_nil;
                });
                
                it(@"tells location manager's delegate that location updates timed out", ^{
                    locationManager.delegate should have_received(@selector(locationManagerBackgroundLocationUpdatesDidTimeout:));
                });
            });
            
            context(@"when timeoutAllowedCheck with allowed date in distant future is called", ^{
                beforeEach(^{
                    locationManager.backgroundLocationServiceTimeoutAllowedDate = [NSDate distantFuture];
                    [locationManager timeoutAllowedCheck];
                });
                
                it(@"then location manager should have not received stopUpdatingLocation", ^{
                    locationManager.locationManager should_not have_received(@selector(stopUpdatingLocation));
                });
                
                it(@"should not reset timeout", ^{
                    locationManager.backgroundLocationServiceTimeoutAllowedDate should_not be_nil;
                });
                
                it(@"then location manager should have not received locationManagerBackgroundLocationUpdatesDidTimeout", ^{
                    locationManager.delegate should_not have_received(@selector(locationManagerBackgroundLocationUpdatesDidTimeout:));
                });
            });
        });
        
        context(@"when the host app is in the foreground, has always location permissions, and after startUpdatingLocation has been called", ^{
            beforeEach(^{
                spy_on([CLLocationManager class]);
                [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusAuthorizedAlways);
                
                locationManager = [[MMELocationManager alloc] init];
                locationManager.delegate = nice_fake_for(@protocol(MMELocationManagerDelegate));
                locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
                
                [locationManager startUpdatingLocation];
            });
            
            context(@"when timeoutAllowedCheck is called and the location manager is updating location", ^{
                beforeEach(^{
                    locationManager.updatingLocation = YES;
                    [locationManager timeoutAllowedCheck];
                });
                
                it(@"then location manager should have not received stopUpdatingLocation", ^{
                    locationManager.locationManager should_not have_received(@selector(stopUpdatingLocation));
                });
                
                it(@"then the location manager's backgroundLocationServiceTimeoutTimer should not be nil", ^{
                    locationManager.backgroundLocationServiceTimeoutTimer should_not be_nil;
                });
            });
            
            context(@"when timeoutAllowedCheck and the location manager is NOT updating location", ^{
                beforeEach(^{
                    locationManager.updatingLocation = NO;
                    [locationManager timeoutAllowedCheck];
                });
                
                it(@"then location manager should have not received stopUpdatingLocation", ^{
                    locationManager.locationManager should_not have_received(@selector(stopUpdatingLocation));
                });
                
                it(@"then location manager's backgroundLocationServiceTimeoutTimer should be nil", ^{
                    locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
                });
            });
        });
        
    });
    
    describe(@"MMELocationManagerDelegate interaction", ^{
        
        context(@"when the host app has always permissions", ^{
            CLLocation *stationaryLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0.0 timestamp:[NSDate date]];
            CLLocation *accurateLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0.0 timestamp:[NSDate date]];
            CLLocation *inaccurateLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) altitude:0 horizontalAccuracy:99999 verticalAccuracy:0 course:0 speed:0.0 timestamp:[NSDate date]];
            CLLocation *movingLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:100.0 timestamp:[NSDate date]];
            CLRegion *expectedRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(0, 0) radius: NSUserDefaults.mme_configuration.mme_backgroundGeofence identifier:MMELocationManagerRegionIdentifier];
            
            beforeEach(^{
                spy_on([CLLocationManager class]);
                [CLLocationManager class] stub_method(@selector(authorizationStatus)).and_return(kCLAuthorizationStatusAuthorizedAlways);
                
                
                locationManager = [[MMELocationManager alloc] init];
                locationManager.delegate = nice_fake_for(@protocol(MMELocationManagerDelegate));
                locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
            });
            
            afterEach(^{
                [NSUserDefaults mme_resetConfiguration];
            });
            
            context(@"when a visit is received", ^{
                __block CLVisit *visit;
                
                beforeEach(^{
                    visit = [[CLVisit alloc] init];
                    [locationManager locationManager:locationManagerInstance didVisit:visit];
                });
                
                afterEach(^{
                    [NSUserDefaults mme_resetConfiguration];
                });
                
                it(@"tells its delegate", ^{
                    locationManager.delegate should have_received(@selector(locationManager:didVisit:)).with(locationManager, visit);
                });
            });
            
            context(@"when a sationary location is received", ^{
                beforeEach(^{
                    [locationManager locationManager:locationManagerInstance didUpdateLocations:@[stationaryLocation]];
                });
                
                afterEach(^{
                    [NSUserDefaults mme_resetConfiguration];
                });
                
                it(@"should not start the timer", ^{
                    locationManager.backgroundLocationServiceTimeoutTimer should be_nil;
                });
            });
            
            context(@"when a moving location is received", ^{
                beforeEach(^{
                    [locationManager locationManager:locationManagerInstance didUpdateLocations:@[movingLocation]];
                });
                
                afterEach(^{
                    [NSUserDefaults mme_resetConfiguration];
                });
                
                it(@"should start the timer", ^{
                    locationManager.backgroundLocationServiceTimeoutTimer should_not be_nil;
                });
            });
            
            describe(@"region monitoring", ^{
                beforeEach(^{
                    [locationManager startUpdatingLocation];
                });
                
                it(@"tells the location manager to start monitoring when there is already a monitored region and an inaccurate location is received", ^{
                    NSSet *newSet = [NSSet setWithObject:[[CLCircularRegion alloc] init]];
                    locationManager.locationManager stub_method(@selector(monitoredRegions)).and_return(newSet);
                    [locationManager locationManager:locationManagerInstance didUpdateLocations:@[inaccurateLocation]];
                    
                    locationManager.locationManager should_not have_received(@selector(startMonitoringForRegion:));
                });
                
                it(@"tells the location manager to start monitoring for region when there are no monitored regions and an accurate location is received", ^{
                    locationManager.locationManager stub_method(@selector(monitoredRegions)).and_return([NSSet set]);
                    expectedRegion.notifyOnEntry = NO;
                    expectedRegion.notifyOnExit = YES;
                    [locationManager locationManager:locationManagerInstance didUpdateLocations:@[accurateLocation]];
                    
                    locationManager.locationManager should have_received(@selector(startMonitoringForRegion:)).with(expectedRegion);
                });
                
                it(@"tells the location manager to start monitoring for region when there are no monitored regions and an inaccurate location is received", ^{
                    locationManager.locationManager stub_method(@selector(monitoredRegions)).and_return([NSSet set]);
                    expectedRegion.notifyOnEntry = NO;
                    expectedRegion.notifyOnExit = YES;
                    [locationManager locationManager:locationManagerInstance didUpdateLocations:@[inaccurateLocation]];
                    
                    locationManager.locationManager should have_received(@selector(startMonitoringForRegion:)).with(expectedRegion);
                });
                
                it(@"informs the location manager's delegate", ^{
                    [locationManager locationManager:locationManagerInstance didUpdateLocations:@[accurateLocation]];
                    locationManager.delegate should have_received(@selector(locationManager:didUpdateLocations:)).with(locationManager).and_with(@[accurateLocation]);
                });
                
                it(@"should exit region", ^{
                    [locationManager locationManager:locationManagerInstance didExitRegion:expectedRegion];
                    
                    locationManager.backgroundLocationServiceTimeoutTimer should_not be_nil;
                    locationManager.locationManager should have_received(@selector(startUpdatingLocation));
                });
                
                it(@"informs the delegate that updates are paused", ^{
                    [locationManager locationManagerDidPauseLocationUpdates:locationManagerInstance];
                    locationManager.delegate should have_received(@selector(locationManagerBackgroundLocationUpdatesDidAutomaticallyPause:)).with(locationManager);
                });
                
                describe(@"- stopMonitoringRegions", ^{
                    __block CLRegion *region;
                    
                    beforeEach(^{
                        region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(0, 0) radius:10 identifier:MMELocationManagerRegionIdentifier];
                        NSSet *newSet = [NSSet setWithObject:region];
                        locationManager.locationManager stub_method(@selector(monitoredRegions)).and_return(newSet);
                        
                        locationManager.updatingLocation = YES;
                        [locationManager stopMonitoringRegions];
                    });
                    
                    afterEach(^{
                        [NSUserDefaults mme_resetConfiguration];
                    });
                    
                    it(@"tells the location manager to stop monitoring for region", ^{
                        locationManager.locationManager should have_received(@selector(stopMonitoringForRegion:)).with(region);
                    });
                });
            });
        });
    });
    
});

SPEC_END
