#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MMEMobileEvents)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
void mme_linkUIKitCategories();
#pragma clang diagnostic pop

@end

#pragma mark -

@interface UIDevice (MMEMobileEvents)

- (NSString *)mme_deviceOrientation;

@end

#pragma mark -

@interface UIApplication (MMEMobileEvents)

- (NSInteger)mme_contentSizeScale;

@end

NS_ASSUME_NONNULL_END
