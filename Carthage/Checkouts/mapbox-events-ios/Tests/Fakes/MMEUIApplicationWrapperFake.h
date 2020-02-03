#import <Foundation/Foundation.h>
#import "MMEUIApplicationWrapper.h"

@interface MMEUIApplicationWrapperFake : NSObject <MMEUIApplicationWrapper>

@property(nonatomic, readwrite) UIApplicationState applicationState;
@property(nonatomic) NSInteger backgroundTaskIdentifier;

@property (nonatomic, nullable) void (^backgroundTaskExpirationHandlerBlock)(void);

- (void)executeBackgroundTaskExpirationWithCompletionHandler;

@end

