#import <Cedar/Cedar.h>
#import "MMEDate.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MMEDateSpec)

describe(@"MMEDate", ^{

    NSTimeInterval const interval = 60; // just a minute

    context(@"+ recordTimeOffsetFromServer:", ^{
        NSDate *serverTime = [NSDate dateWithTimeIntervalSinceNow:interval];
        NSTimeInterval recorded = [MMEDate recordTimeOffsetFromServer:serverTime];

        it(@"computes offsets from server time", ^{
            round(recorded) should equal(round(interval));
        });
    });

    context(@"+ recordedTimeOffsetFromServer:", ^{
        NSDate *serverTime = [NSDate dateWithTimeIntervalSinceNow:interval];
        NSTimeInterval computed = [MMEDate recordTimeOffsetFromServer:serverTime];
        NSTimeInterval recorded = [MMEDate recordedTimeOffsetFromServer];

        it(@"checks computed and recorded", ^{
            computed should equal(recorded);
        });

        it(@"checks the computed interval", ^{
            round(computed) should equal(round(interval));
        });

        it(@"check the recorded interval", ^{
            round(recorded) should equal(round(interval));
        });
    });

    context(@"clear timeOffsetFromServer:", ^{
        NSTimeInterval interval = [MMEDate recordTimeOffsetFromServer:NSDate.date];
        NSTimeInterval recorded = [MMEDate recordedTimeOffsetFromServer];

        it(@"should be a short interval", ^{
            interval should be_close_to(0.0);
        });

        it(@"shoul have reset the recorded offset", ^{
            recorded should be_close_to(0.0);
        });
    });

    context(@"- initWithOffset:", ^{
        MMEDate *offset = [MMEDate.alloc initWithOffset:interval];

        it(@"correctly records offsetFromServer", ^{
            offset.offsetFromServer should equal(interval);
        });
    });

    context(@"- offsetToServer:", ^{
        NSDate *serverTime = [NSDate dateWithTimeIntervalSinceNow:interval];
        MMEDate *offset = [MMEDate.alloc initWithOffset:interval];

        it(@"correctly computes offsetToServer date", ^{
            round(offset.offsetToServer.timeIntervalSinceReferenceDate) should equal(round(serverTime.timeIntervalSinceReferenceDate));
        });
    });

    context(@"+ iso8601DateFormatter stringFromDate:", ^{
        it(@"has the correct date format", ^{
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:213242];
            NSString *dateString = [MMEDate.iso8601DateFormatter stringFromDate:date];
            
            dateString should equal(@"1970-01-03T11:14:02.000+0000");
        });
    });

    context(@"- mme_startOfTomorrow", ^{
        MMEDate *now = MMEDate.date;
        NSDate *later = now.mme_startOfTomorrow;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        it(@"should be in the future", ^{
            [later timeIntervalSinceDate:now] should be_greater_than(0);
        });

        it(@"should be less than 24 hours in the future", ^{
            NSTimeInterval oneDay = (60 * 60 * 24); // S * M * H
            [later timeIntervalSinceDate:now] should be_less_than(oneDay);
        });

        it(@"should be exactly midnight", ^{
            NSUInteger laterHours = [calendar component:NSCalendarUnitHour fromDate:later];
            NSUInteger laterMinutes = [calendar component:NSCalendarUnitMinute fromDate:later];
            NSUInteger laterSeconds = [calendar component:NSCalendarUnitSecond fromDate:later];

            laterHours should equal(0);
            laterMinutes should equal(0);
            laterSeconds should equal(0);
        });
    });

    context(@"NSSecureCoding", ^{
        MMEDate *now = [MMEDate new];
        NSKeyedArchiver *archiver = [NSKeyedArchiver new];
        archiver.requiresSecureCoding = YES;
        [archiver encodeObject:now forKey:NSKeyedArchiveRootObjectKey];
        NSData* nowData = archiver.encodedData;

        it(@"should encode to nowData", ^{
            nowData should_not be_nil;
            nowData.length should be_greater_than(0);
        });

        it(@"should decode from data", ^{
            NSKeyedUnarchiver *unarchiver = [NSKeyedUnarchiver.alloc initForReadingWithData:nowData];
            unarchiver.requiresSecureCoding = YES;
            MMEDate *then = [unarchiver decodeObjectOfClass:MMEDate.class forKey:NSKeyedArchiveRootObjectKey];
            then should_not be_nil;
            then.timeIntervalSinceReferenceDate should equal(now.timeIntervalSinceReferenceDate);
        });
    });

    context(@"NSKeyedArchiver", ^{
        MMEDate *now = [MMEDate new];
        NSString *tempFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"MMEDate-now.data"];
        if ([NSFileManager.defaultManager fileExistsAtPath:tempFile]) {
            [NSFileManager.defaultManager removeItemAtPath:tempFile error:nil];
        }
        [NSKeyedArchiver archiveRootObject:now toFile:tempFile];
        NSData *thenData = [NSData dataWithContentsOfFile:tempFile];
        NSKeyedUnarchiver* unarchiver = [NSKeyedUnarchiver.alloc initForReadingWithData:thenData];
        unarchiver.requiresSecureCoding = YES;
        MMEDate *then = [unarchiver decodeObjectOfClass:MMEDate.class forKey:NSKeyedArchiveRootObjectKey];

        it(@"should write encoded data to a file/read data and decode from a file", ^{
            [NSFileManager.defaultManager fileExistsAtPath:tempFile] should be_truthy;
        });

        it(@"should read data and decode from a file", ^{
            then should_not be_nil;
            then.timeIntervalSinceReferenceDate should equal(now.timeIntervalSinceReferenceDate);
        });
    });
});

SPEC_END
