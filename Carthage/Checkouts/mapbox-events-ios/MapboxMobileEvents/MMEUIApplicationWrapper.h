#import <UIKit/UIKit.h>

@protocol MMEUIApplicationWrapper <NSObject>

@property(nonatomic, readonly) UIApplicationState applicationState;

- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithExpirationHandler:(void(^ __nullable)(void))handler;
- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)identifier;

@end

@interface MMEUIApplicationWrapper : NSObject <MMEUIApplicationWrapper>

@end
