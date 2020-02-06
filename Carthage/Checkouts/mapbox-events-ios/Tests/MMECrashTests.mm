#import <Cedar/Cedar.h>
#import "MMEConstants.h"
#import "MMEEvent.h"
#import "MMEEventsManager.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MMECrashSpec)

describe(@"MMEEventsManager", ^{

    context(@"- reportError:", ^{
        NSError *testError = [NSError errorWithDomain:MMEErrorDomain code:-666 userInfo:nil];
        MMEEvent *testEvent = [MMEEventsManager.sharedManager reportError:testError];

        it(@"should return an event", ^{
            testEvent should_not be_nil;
        });
    });

    context(@"- reportException:", ^{
        NSException *testException = [NSException exceptionWithName:NSGenericException reason:MMEEventKeyErrorNoReason userInfo:nil];
        MMEEvent *testEvent = [MMEEventsManager.sharedManager reportException:testException];

        it(@"should return an event", ^{
            testEvent should_not be_nil;
        });
    });

    context(@"- report raised and caught exception", ^{
        NSException *testException = [NSException exceptionWithName:NSGenericException reason:MMEEventKeyErrorNoReason userInfo:nil];
        @try {
            [testException raise];
        }
        @catch (NSException *exception) {
            MMEEvent *testEvent = [MMEEventsManager.sharedManager reportException:testException];
            
            it(@"should return an event", ^{
                testEvent should_not be_nil;
            });
        }
    });
});

SPEC_END
