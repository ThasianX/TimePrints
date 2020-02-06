#import <Foundation/Foundation.h>
#import "MMEMetrics.h"

NS_ASSUME_NONNULL_BEGIN

@class MMEEvent;

@interface MMEMetricsManager : NSObject

@property (nonatomic, readonly) MMEMetrics *metrics;

+ (instancetype)sharedManager;

- (void)updateSentBytes:(NSUInteger)bytes;
- (void)updateReceivedBytes:(NSUInteger)bytes;
- (void)updateMetricsFromEventQueue:(NSArray *)eventQueue;
- (void)updateMetricsFromEventCount:(NSUInteger)eventCount request:(nullable NSURLRequest *)request error:(nullable NSError *)error;
- (void)updateConfigurationJSON:(NSDictionary *)configuration;
- (void)updateCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)incrementAppWakeUpCount;
- (void)resetMetrics;

/*! @brief loads any pending telemetry metrics events from ~/Library/Caches */
- (MMEEvent *)loadPendingTelemetryMetricsEvent;

/*! @brief generates an event with the current telemetry metrics
    @return nil for pending events, or a telemetry event which is ready to send
    @discussion if this method returns nil the framework will write the pending telemetry metrics
    to a file in ~/Library/Caches, this event may be loaded with -loadPendingTelemetryMetricsEvent */
- (MMEEvent *)generateTelemetryMetricsEvent;

- (NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_END
