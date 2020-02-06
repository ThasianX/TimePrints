#import "MMECommonEventData.h"
#import "MMEConstants.h"

#if TARGET_OS_IOS || TARGET_OS_TVOS
#import <UIKit/UIKit.h>
#endif
#include <sys/sysctl.h>

NSString * const MMEApplicationStateForeground = @"Foreground";
NSString * const MMEApplicationStateBackground = @"Background";
NSString * const MMEApplicationStateInactive = @"Inactive";
NSString * const MMEApplicationStateUnknown = @"Unknown";

@implementation MMECommonEventData

+ (NSString *)sysInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);

    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);

    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

+ (NSMutableDictionary *)commonCrashEventData {
    NSMutableDictionary *eventDictionary = NSMutableDictionary.new;
    MMECommonEventData *eventData = MMECommonEventData.new;

    if (eventData.model) {
        eventDictionary[MMEEventKeyModel] = eventData.model;
    }

    if (eventData.osVersion) {
        eventDictionary[MMEEventKeyOSVersion] = eventData.osVersion;
    }

    if (eventData.device) {
        eventDictionary[MMEEventKeyDevice] = eventData.device;
    }

    return eventDictionary;
}

#pragma mark -

- (instancetype)init {
    if (self = [super init]) {
        _model = [MMECommonEventData sysInfoByName:"hw.machine"];
        _platform = [MMECommonEventData platformInfo];
#if TARGET_OS_IOS || TARGET_OS_TVOS
        _vendorId = UIDevice.currentDevice.identifierForVendor.UUIDString;
        _osVersion = [NSString stringWithFormat:@"%@ %@", UIDevice.currentDevice.systemName, UIDevice.currentDevice.systemVersion];
        _device = UIDevice.currentDevice.model;
        if ([UIScreen instancesRespondToSelector:@selector(nativeScale)]) {
            _scale = UIScreen.mainScreen.nativeScale;
        } else {
            _scale = UIScreen.mainScreen.scale;
        }
#else
        _vendorId = nil;
        _osVersion = NSProcessInfo.processInfo.operatingSystemVersionString;
        _scale = 0;
#endif
    }
    return self;
}

+ (NSString *)applicationState {
#if TARGET_OS_IOS || TARGET_OS_TVOS
    switch (UIApplication.sharedApplication.applicationState) {
        case UIApplicationStateActive:
            return MMEApplicationStateForeground;
        case UIApplicationStateInactive:
            return MMEApplicationStateInactive;
        case UIApplicationStateBackground:
            return MMEApplicationStateBackground;
        default:
            return MMEApplicationStateUnknown;
    }
#else
    return MMEApplicationStateUnknown;
#endif
}

+ (NSString *)platformInfo {
    NSString *result;
    #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        result = MMEEventKeyiOS;
    #elif TARGET_OS_MACOS
        result = MMEEventKeyMac;
    #else
        result = MMEEventUnknown;
    #endif
    
    return result;
}


@end
