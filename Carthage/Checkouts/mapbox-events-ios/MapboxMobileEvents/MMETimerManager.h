#import <Foundation/Foundation.h>

@interface MMETimerManager : NSObject

@property (nonatomic, readonly) NSTimeInterval timeInterval;
@property (nonatomic, readonly) id target;
@property (nonatomic, readonly) SEL selector;

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)aTarget selector:(SEL)selector;

- (void)start;
- (void)cancel;

@end
