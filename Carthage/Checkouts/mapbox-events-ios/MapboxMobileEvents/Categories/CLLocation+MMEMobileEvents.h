#import <CoreLocation/CoreLocation.h>

@interface CLLocation (MMEMobileEvents)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
void mme_linkCLLocationCategory();
#pragma clang diagnostic pop


- (CLLocationDistance)mme_roundedAltitude;
- (CLLocationAccuracy)mme_roundedHorizontalAccuracy;
- (CLLocationDegrees)mme_latitudeRoundedWithPrecision:(NSUInteger)precision;
- (CLLocationDegrees)mme_longitudeRoundedWithPrecision:(NSUInteger)precision;

@end
