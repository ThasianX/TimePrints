#import "MMEUniqueIdentifier.h"

@interface MMEUniqueIdentifier ()

@property (nonatomic) NSDate *instanceIDRotationDate;
@property (nonatomic) NSString *instanceID;

@end

@implementation MMEUniqueIdentifier

- (instancetype)init {
    NSAssert(false, @"Use `-[MMEUniqueIdentifier initWithTimeInterval:]` to create instances of this class.");
    return nil;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval {
    if (self = [super init]) {
        _timeInterval = timeInterval;
    }
    return self;
}

- (NSString *)rollingInstanceIdentifer {
    if (self.instanceIDRotationDate && [[NSDate date] timeIntervalSinceDate:self.instanceIDRotationDate] >= 0) {
        _instanceID = nil;
    }
    if (!_instanceID) {
        _instanceID = [[NSUUID UUID] UUIDString];
        self.instanceIDRotationDate = [[NSDate date] dateByAddingTimeInterval:self.timeInterval];
    }
    return _instanceID;
}

@end
