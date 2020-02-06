#import "CLLocation+MMEMobileEvents.h"

@implementation CLLocation (MMEMobileEvents)

void mme_linkCLLocationCategory(){}

- (CLLocationDistance)mme_roundedAltitude {
    return round(self.altitude);
}

- (CLLocationAccuracy)mme_roundedHorizontalAccuracy {
    return round(self.horizontalAccuracy);
}

- (CLLocationDegrees)mme_latitudeRoundedWithPrecision:(NSUInteger)precision {
    return [self value:self.coordinate.latitude withPrecision:precision];
}

- (CLLocationDegrees)mme_longitudeRoundedWithPrecision:(NSUInteger)precision {
    return [self value:self.coordinate.longitude withPrecision:precision];
}

- (CLLocationDegrees)value:(CLLocationDegrees)value withPrecision:(NSUInteger)precision {
    double accuracy = pow(10.0, precision);
    return floor(value * accuracy) / accuracy;
}

@end
