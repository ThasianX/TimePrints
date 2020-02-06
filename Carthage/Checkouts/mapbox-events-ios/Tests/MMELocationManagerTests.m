#import <XCTest/XCTest.h>

#import "MMELocationManager.h"

#import "NSUserDefaults+MMEConfiguration.h"
#import "NSUserDefaults+MMEConfiguration_Private.h"

@interface MMELocationManagerTests : XCTestCase <MMELocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) MMELocationManager *mme_locationManager;

@end

@interface MMELocationManager (Spec) <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation MMELocationManagerTests

- (void)setUp {
    [NSUserDefaults mme_resetConfiguration];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.mme_locationManager = [[MMELocationManager alloc] init];
    
    self.mme_locationManager.locationManager = self.locationManager;
    self.mme_locationManager.delegate = self;
}

- (void)tearDown {
    [NSUserDefaults mme_resetConfiguration];
}

- (void)testLocationManagerStartsMonitoringRegions {
    CLLocation *movingLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:100.0 timestamp:[NSDate date]];
    
    [self.mme_locationManager locationManager:self.locationManager didUpdateLocations:@[movingLocation]];
    
    XCTAssert(self.locationManager.monitoredRegions > 0);
}

@end
