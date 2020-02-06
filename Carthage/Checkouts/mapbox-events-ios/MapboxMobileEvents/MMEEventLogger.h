#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MMETypes.h"

@class MMEEvent;

NS_ASSUME_NONNULL_BEGIN

@interface MMEEventLogger : NSObject

@property (nonatomic, getter=isEnabled) BOOL enabled;

+ (instancetype)sharedLogger;

- (void)logEvent:(MMEEvent *)event;
- (void)readAndDisplayLogFileFromDate:(NSDate *)logDate;
- (void)pushDebugEventWithAttributes:(MMEMapboxEventAttributes *)attributes;

@end

NS_ASSUME_NONNULL_END

