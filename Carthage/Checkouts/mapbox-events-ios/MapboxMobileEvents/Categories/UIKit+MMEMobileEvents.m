#import "UIKit+MMEMobileEvents.h"

@implementation NSObject (MMEMobileEvents)

void mme_linkUIKitCategories(){};

@end

#pragma mark -

@implementation UIDevice (MMEMobileEvents)

- (NSString *)mme_deviceOrientation {
    NSString *result;
    switch (self.orientation) {
        case UIDeviceOrientationUnknown:
            result = @"Unknown";
            break;
        case UIDeviceOrientationPortrait:
            result = @"Portrait";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            result = @"PortraitUpsideDown";
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = @"LandscapeLeft";
            break;
        case UIDeviceOrientationLandscapeRight:
            result = @"LandscapeRight";
            break;
        case UIDeviceOrientationFaceUp:
            result = @"FaceUp";
            break;
        case UIDeviceOrientationFaceDown:
            result = @"FaceDown";
            break;
        default:
            result = @"Default - Unknown";
            break;
    }
    return result;
}

@end

#pragma mark -

@implementation UIApplication (MMEMobileEvents)

- (NSInteger)mme_contentSizeScale {
    NSInteger result = -9999;

    NSString *sc = self.preferredContentSizeCategory;

    if ([sc isEqualToString:UIContentSizeCategoryExtraSmall]) {
        result = -3;
    } else if ([sc isEqualToString:UIContentSizeCategorySmall]) {
        result = -2;
    } else if ([sc isEqualToString:UIContentSizeCategoryMedium]) {
        result = -1;
    } else if ([sc isEqualToString:UIContentSizeCategoryLarge]) {
        result = 0;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraLarge]) {
        result = 1;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        result = 2;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        result = 3;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityMedium]) {
        result = -11;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityLarge]) {
        result = 10;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge]) {
        result = 11;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) {
        result = 12;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) {
        result = 13;
    }

    return result;
}

@end
