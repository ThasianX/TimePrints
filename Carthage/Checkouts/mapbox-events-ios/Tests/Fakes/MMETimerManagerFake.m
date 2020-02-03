#import "MMETimerManagerFake.h"
#import <objc/message.h>

@implementation MMETimerManagerFake

@synthesize timeInterval;
@synthesize target;
@synthesize selector;

- (void)triggerTimer {
     ((void(*)(id, SEL))objc_msgSend)(self.target, self.selector);
}

@end
