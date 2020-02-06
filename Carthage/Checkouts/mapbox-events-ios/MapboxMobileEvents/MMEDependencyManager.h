#import <Foundation/Foundation.h>

@class CLLocationManager;

@interface MMEDependencyManager : NSObject

+ (instancetype)sharedManager;

- (CLLocationManager *)locationManagerInstance;

@end
