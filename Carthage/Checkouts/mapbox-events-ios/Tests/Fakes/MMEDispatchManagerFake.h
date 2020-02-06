#import "MMEDispatchManager.h"

@interface MMEDispatchManagerFake : MMEDispatchManager

@property (nonatomic) NSTimeInterval delay;

- (void)scheduleBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
