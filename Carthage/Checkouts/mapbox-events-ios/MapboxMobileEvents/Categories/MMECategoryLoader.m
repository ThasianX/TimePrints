#import "MMECategoryLoader.h"

#import "CLLocationManager+MMEMobileEvents.h"
#import "CLLocation+MMEMobileEvents.h"
#import "NSData+MMEGZIP.h"
#if TARGET_OS_IOS || TARGET_OS_TV
#import "UIKit+MMEMobileEvents.h"
#endif

@implementation MMECategoryLoader

//forces the classes called by these methods to be included in the binary.
//used to prevent crashes and simplify installation for developers of the library.
+ (void)loadCategories {
    mme_linkCLLocationManagerCategory();
    mme_linkCLLocationCategory();
    mme_linkNSDataCategory();
#if TARGET_OS_IOS || TARGET_OS_TV
    mme_linkUIKitCategories();
#endif
}

@end
