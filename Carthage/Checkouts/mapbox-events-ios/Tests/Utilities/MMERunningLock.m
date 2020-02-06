#import "MMERunningLock.h"

@implementation MMERunningLock

+ (MMERunningLock *)lockedRunningLock {
    MMERunningLock *running = [MMERunningLock new];
    [running lock];
    return running ;
}

- (BOOL) runUntilTimeout:(NSTimeInterval)lockTimeout withQuantum:(NSTimeInterval)quantum{
    BOOL didLock = NO;
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:lockTimeout];
    while (!(didLock = [self lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:quantum]])
      && timeout.timeIntervalSinceNow < 0) {
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:quantum]];
    }
    return didLock;
}

- (BOOL) runUntilTimeout:(NSTimeInterval)lockTimeout {
    return [self runUntilTimeout:lockTimeout withQuantum:1];
}

@end
