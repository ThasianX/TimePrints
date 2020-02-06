#import "MMEUIApplicationWrapperFake.h"

@implementation MMEUIApplicationWrapperFake

- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithExpirationHandler:(void (^ _Nullable)(void))handler {
    
    _backgroundTaskExpirationHandlerBlock = handler;
    
    return self.backgroundTaskIdentifier;
}

- (void)executeBackgroundTaskExpirationWithCompletionHandler {
    if (self.backgroundTaskExpirationHandlerBlock) {
        self.backgroundTaskExpirationHandlerBlock();
    }
}

- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)identifier {
}

@end

