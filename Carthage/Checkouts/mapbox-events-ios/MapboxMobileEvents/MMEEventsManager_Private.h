#ifndef MMEEventsManager_Private_h
#define MMEEventsManager_Private_h

NS_ASSUME_NONNULL_BEGIN

@class MMEAPIClient;

@interface MMEEventsManager (Private)

- (void)pushEvent:(MMEEvent *)event;

@end

NS_ASSUME_NONNULL_END

#endif /* MMEEventsManager_Private_h */
