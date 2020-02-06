@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface MMERunningLock : NSLock

+ (MMERunningLock *)lockedRunningLock;

- (BOOL) runUntilTimeout:(NSTimeInterval)lockTimeout;

@end

NS_ASSUME_NONNULL_END
