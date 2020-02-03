#import "MMEUIApplicationWrapper.h"

@implementation MMEUIApplicationWrapper

- (UIApplicationState)applicationState {
    return [UIApplication sharedApplication].applicationState;
}

- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithExpirationHandler:(void(^ __nullable)(void))handler {
    return [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:handler];
}

- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)identifier {
    [[UIApplication sharedApplication] endBackgroundTask:identifier];
}

@end
