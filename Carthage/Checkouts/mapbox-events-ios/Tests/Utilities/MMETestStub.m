#import "MMETestStub.h"

@implementation MMETestStub

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectors = [NSMutableSet set];
        _argumentsBySelector = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)resetReceivedSelectors {
    _selectors = [NSMutableSet set];
}

- (BOOL)received:(SEL)selector {
    NSValue *lookup = [NSValue valueWithPointer:selector];
    return [self.selectors containsObject:lookup];
}

- (BOOL)received:(SEL)selector withArguments:(NSArray *)arguments {
    NSValue *lookup = [NSValue valueWithPointer:selector];
    BOOL selectorCalled = [self received:selector];
    arguments = arguments != nil ? arguments : @[];
    BOOL argumentsPassed = [self.argumentsBySelector[lookup] isEqualToArray:arguments];
    return selectorCalled && argumentsPassed;
}

- (void)store:(SEL)sel args:(NSArray *)args {
    NSValue *method = [NSValue valueWithPointer:sel];
    args = args != nil ? args : @[];
    self.argumentsBySelector[method] = args;
    [self.selectors addObject:method];
}

@end
