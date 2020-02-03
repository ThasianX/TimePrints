#import "MMETimerManager.h"

@interface MMETimerManager ()

@property (nonatomic) NSTimer *timer;

@end

@implementation MMETimerManager

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)aTarget selector:(SEL)selector {
    if (self = [super init]) {
        _timeInterval = timeInterval;
        _target = aTarget;
        _selector = selector;
    }
    return self;
}

- (void)start {
    [self cancel];
    // NOTE: this has the side-effect of scheduling the timer on the current or main run loop.
    // Once delayed startup is implemented, the scheduling of this timer may also need to be delayed
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval
                                                  target:self.target
                                                selector:self.selector
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)cancel {
    [self.timer invalidate];
    self.timer = nil;
}

@end
