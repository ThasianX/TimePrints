#import <CoreLocation/CoreLocation.h>

@interface CLLocationManager (MMEMobileEvents)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
void mme_linkCLLocationManagerCategory();
#pragma clang diagnostic pop

+ (NSString *)mme_authorizationStatusString;

@end
