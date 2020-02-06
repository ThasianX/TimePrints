#import <Cedar/Cedar.h>
#import "MMEDependencyManager.h"
#import <CoreLocation/CoreLocation.h>

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MMEDependencyManagerSpec)

describe(@"MMEDependencyManager", ^{
    
    __block MMEDependencyManager *manager;
    
    beforeEach(^{
        manager = [MMEDependencyManager sharedManager];
    });
    
    describe(@"- locationManagerInstance", ^{
        
        it(@"returns expected instance of locationManager", ^{
            [manager locationManagerInstance] should be_instance_of([CLLocationManager class]);
        });
        
    });
    
});

SPEC_END
