#import <Foundation/Foundation.h>

@interface MMETestStub : NSObject

@property (nonatomic) NSMutableSet *selectors;
@property (nonatomic) NSMutableDictionary *argumentsBySelector;

- (void)resetReceivedSelectors;
- (BOOL)received:(SEL)selector;
- (BOOL)received:(SEL)selector withArguments:(NSArray *)arguments;
- (void)store:(SEL)sel args:(NSArray *)args;

@end
