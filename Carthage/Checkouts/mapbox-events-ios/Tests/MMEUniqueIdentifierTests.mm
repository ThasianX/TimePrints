#import <Cedar/Cedar.h>
#import "MMEUniqueIdentifier.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface MMEUniqueIdentifier (Spec)
@property (nonatomic) NSDate *instanceIDRotationDate;
@end

SPEC_BEGIN(MMEUniqueIdentifierSpec)

describe(@"MMEUniqueIdentifier", ^{
    
    __block MMEUniqueIdentifier *uniqueIdentifier;
    
    beforeEach(^{
        uniqueIdentifier = [[MMEUniqueIdentifier alloc] initWithTimeInterval:3600];
    });
    
    describe(@"- rollingInstanceIdentifer", ^{
        __block NSString *firstId;
        
        beforeEach(^{
            firstId = [uniqueIdentifier rollingInstanceIdentifer];
        });
        
        context(@"when the instance ID rotation date threshold has not been passed", ^{
            it(@"returns the same value", ^{
                [uniqueIdentifier rollingInstanceIdentifer] should equal(firstId);
            });
        });
        
        context(@"when the instance ID rotation date threshold has been passed", ^{
            it(@"returns a different value", ^{
                uniqueIdentifier.instanceIDRotationDate = [NSDate distantPast];
                uniqueIdentifier.rollingInstanceIdentifer should_not equal(firstId);
            });
        });
    });
             
});

SPEC_END
