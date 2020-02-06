#import <Foundation/Foundation.h>

/*! @brief MMEDate is a subclass of NSDate which stores information needed to compute clock offsets from servers */
@interface MMEDate : NSDate

/*! @brief store the recorded time offset for the date when created using the +[MMEDate date] or +[MMEDate dateWithOffsetFromServer:(NSTimeInterval)offset]` methods */
@property(nonatomic,assign,readonly) NSTimeInterval offsetFromServer;

/*! @brief computes, records and returns the time offset from the server's time frame */
+ (NSTimeInterval)recordTimeOffsetFromServer:(NSDate *)responseDate;

/*! @brief returns the recorded time offset from the server's time frame */
+ (NSTimeInterval)recordedTimeOffsetFromServer;

/*! @brief UTC yyyy-MM-dd'T'HH:mm:ss.SSSZ formatter */
+ (NSDateFormatter *)iso8601DateFormatter;

/*! @brief UTC yyyy-MM-dd formatter */
+ (NSDateFormatter *)iso8601DateOnlyFormatter;

/*! @brief local time yyyy-MM-dd formatter */
+ (NSDateFormatter *)logDateFormatter;

/*! @biref HTTP-date formatter
    @link https://tools.ietf.org/html/rfc7231#section-7.1.1.1
*/
+ (NSDateFormatter *)HTTPDateFormatter;

/*! @brief returns a date with the recordedTimeOffsetFromServer */
+ (MMEDate *)dateWithRecordedOffset;

/*! @brief returns a date with the specified timeOffsetFromServer */
+ (MMEDate *)dateWithOffset:(NSTimeInterval)serverTimeFrame;

/*! @brief return an MMEDate with the time specified in the provided date */
+ (MMEDate *)dateWithDate:(NSDate *)date;

#pragma mark -

- (MMEDate *)initWithOffset:(NSTimeInterval)serverTimeFrame;

#pragma mark -

/*! @brief returns the date, with the offsetFromServer adjustment applied, putting the date in the server's time frame  */
- (NSDate *)offsetToServer;

@end

#pragma mark -

@interface NSDate (MMEDate)

/*! @brief returns a date at 00:00:00 on the next calendar day */
- (NSDate *)mme_startOfTomorrow;

@end
