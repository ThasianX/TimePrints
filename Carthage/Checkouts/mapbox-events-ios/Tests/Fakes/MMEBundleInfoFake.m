#import "MMEBundleInfoFake.h"

@implementation MMEBundleInfoFake

+ (MMEBundleInfoFake *)bundleWithFakeInfo:(NSDictionary *)fakeInfo {
    MMEBundleInfoFake *fakeBundle = [MMEBundleInfoFake new];
    fakeBundle.infoDictionaryFake = fakeInfo;
    return fakeBundle;
}

- (NSDictionary*) infoDictionary {
    if (self.infoDictionaryFake) {
        return self.infoDictionaryFake;
    }
    else return [super infoDictionary];
}

@end
