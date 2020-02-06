#import "MMEExceptionalDictionary.h"

@interface MMEExceptionalDictionary ()
@property(nonatomic) NSDictionary* inner;

@end

#pragma mark -

@implementation MMEExceptionalDictionary

- (instancetype) initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    if (self = [super init]) {
        self.inner = [NSDictionary.alloc initWithObjects:objects forKeys:keys count:cnt];
    }
    return self;
}

- (instancetype) mutableCopy {
    [[NSException exceptionWithName:NSGenericException reason:@"testing" userInfo:nil] raise];
    return nil;
}

- (NSUInteger) count {
    return self.inner.count;
}

- (NSEnumerator *)keyEnumerator {
    return self.inner.keyEnumerator;
}

- (id)objectForKey:(id)aKey {
    return [self.inner objectForKey:aKey];
}

@end
