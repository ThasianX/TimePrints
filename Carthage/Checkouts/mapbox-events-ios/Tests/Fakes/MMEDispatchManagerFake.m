#import "MMEDispatchManagerFake.h"

@implementation MMEDispatchManagerFake

- (void)scheduleBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    self.delay = delay;
    block();
}


@end
