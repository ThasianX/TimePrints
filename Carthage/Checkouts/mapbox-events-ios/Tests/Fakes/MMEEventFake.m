#import "MMEEventFake.h"


@implementation MMEEventFake

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:NSIntegerMax forKey:@"MMEEventVersion"];
}



@end
