#import "MMELocationManagerFake.h"

@implementation MMELocationManagerFake

- (void)startUpdatingLocation {
    [self store:_cmd args:nil];
}

- (void)stopUpdatingLocation {
    [self store:_cmd args:nil];
}

@end
