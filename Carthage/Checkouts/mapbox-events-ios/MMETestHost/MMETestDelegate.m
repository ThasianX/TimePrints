#import "MMETestDelegate.h"

// MARK: -

@implementation MMETestDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

@end

// MARK: - main

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(MMETestDelegate.class));
    }
}
