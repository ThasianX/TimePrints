#import <Cedar/Cedar.h>
#import <CoreLocation/CoreLocation.h>

#import "MMEEvent.h"
#import "MMECommonEventData.h"
#import "MMEMetricsManager.h"
#import "MMEConstants.h"
#import "MMEReachability.h"
#import "MMEEventFake.h"

@interface MMEMetricsManager (Private)

+ (NSString *)pendingMetricsEventPath;

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(MMEMetricsManagerSpec)

describe(@"MMEMetricsManager", ^{
    
    __block MMEMetricsManager *manager;
    
    beforeEach(^{
        manager = [[MMEMetricsManager alloc] init];
    });
    
    describe(@"- MMEMetricsManagerInstance", ^{
        
        __block NSArray *eventQueue;
        __block NSDateFormatter *dateFormatter;
        __block NSURLRequest *requestFake;
        
        beforeEach(^{
            NSString *dateString = @"A nice date";
            NSDictionary *attributes = @{@"attribute1": @"a nice attribute"};
            
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            
            MMEEvent *event1 = [MMEEvent mapTapEventWithDateString:dateString attributes:attributes];
            MMEEvent *event2 = [MMEEvent mapTapEventWithDateString:dateString attributes:attributes];
            eventQueue = [[NSArray alloc] initWithObjects:event1, event2, nil];
            
            requestFake = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://areallyniceURL"]];
        });
    
        context(@"when incrementing eventQueue metrics", ^{
            beforeEach(^{
                [manager updateMetricsFromEventQueue:eventQueue];
            });
            
            it(@"should have total count increase", ^{
                manager.metrics.eventCountTotal should equal(2);
            });
            
            it(@"should have event count per type increase", ^{
                manager.metrics.eventCountPerType.count should equal(1);
            });
            
            it(@"should have event count per type object count increase", ^{
                [manager.metrics.eventCountPerType objectForKey:MMEEventTypeMapTap] should equal(@2);
            });
            
            it(@"should set recordingStarted date", ^{
                manager.metrics.recordingStarted should_not be_nil;
            });
        });
        
        context(@"when preparing attributes", ^{
            __block NSString *dateString = nil;

            beforeEach(^{
                dateString = manager.attributes[MMEEventDateUTC];
            });

            it(@"should set MMEEventDateUTC attributes", ^{
                dateString should_not be_nil;
            });

            it(@"should set MMEEventDateUTC to ISO 8501 Format", ^{
                [dateFormatter dateFromString:dateString] should_not be_nil;
            });
        });
        
        context(@"when incrementing failed HTTP response metrics", ^{
            beforeEach(^{
                NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"events.mapbox.com"] statusCode:404 HTTPVersion:nil headerFields:nil];
                NSDictionary *userInfoFake = [NSDictionary dictionaryWithObject:response forKey:MMEResponseKey];
                NSError *errorFake = [NSError errorWithDomain:@"test" code:42 userInfo:userInfoFake];
                
                [manager updateMetricsFromEventCount:eventQueue.count request:requestFake error:errorFake];
                [manager updateMetricsFromEventCount:eventQueue.count request:requestFake error:errorFake];
                
                NSHTTPURLResponse *responseTwo = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"events.mapbox.com"] statusCode:500 HTTPVersion:nil headerFields:nil];
                NSDictionary *userInfoFakeTwo = [NSDictionary dictionaryWithObject:responseTwo forKey:MMEResponseKey];
                NSError *errorFakeTwo = [NSError errorWithDomain:@"test" code:42 userInfo:userInfoFakeTwo];
                
                [manager updateMetricsFromEventCount:eventQueue.count request:requestFake error:errorFakeTwo];
            });
            
            it(@"should have failedRequests 404 count increased", ^{
                NSDictionary *failedRequestsDict = [manager.metrics.failedRequestsDict objectForKey:MMEEventKeyFailedRequests];
                [failedRequestsDict objectForKey:@"404"] should equal(@2);
            });
            
            it(@"should have failedRequests 500 count increased", ^{
                NSDictionary *failedRequestsDict = [manager.metrics.failedRequestsDict objectForKey:MMEEventKeyFailedRequests];
                [failedRequestsDict objectForKey:@"500"] should equal(@1);
            });
            
            it(@"should have header in dictionary", ^{
                [manager.metrics.failedRequestsDict objectForKey:MMEEventKeyHeader] should_not be_nil;
            });
            
            it(@"should have all keys count increased", ^{
                [manager.metrics.failedRequestsDict allKeys].count should equal(2);
            });
            
            it(@"should have eventCountFailed count increased", ^{
                manager.metrics.eventCountFailed should equal(6);
            });
            
            it(@"should not have total count increase", ^{
                manager.metrics.eventCountTotal should equal(0);
            });
            
            it(@"should have request count NOT increased", ^{
                manager.metrics.requests should equal(0);
            });
        });
        
        context(@"when incrementing successful HTTP requests", ^{
            beforeEach(^{
                [manager updateMetricsFromEventCount:eventQueue.count request:requestFake error:nil];
            });
            
            it(@"should have request count increased", ^{
                manager.metrics.requests should equal(1);
            });
        });
        
        context(@"when incrementing data transfer metrics", ^{
            __block NSData *uncompressedData;
            
            beforeEach(^{
                MMECommonEventData *commonEventData = [[MMECommonEventData alloc] init];
                commonEventData.vendorId = @"vendor-id";
                commonEventData.model = @"model";
                commonEventData.osVersion = @"1";
                commonEventData.scale = 42;
                
                MMEEvent *event = [MMEEvent locationEventWithAttributes:@{} instanceIdentifer:@"instance-id-1" commonEventData:commonEventData];
                MMEEvent *eventTwo = [MMEEvent locationEventWithAttributes:@{} instanceIdentifer:@"instance-id-1" commonEventData:commonEventData];
                
                NSArray *events = @[event, eventTwo];
                
                NSMutableArray *eventAttributes = [NSMutableArray arrayWithCapacity:events.count];
                [events enumerateObjectsUsingBlock:^(MMEEvent * _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (event.attributes) {
                        [eventAttributes addObject:event.attributes];
                    }
                }];
                
                uncompressedData = [NSJSONSerialization dataWithJSONObject:eventAttributes options:0 error:nil];
                
                [manager updateSentBytes:uncompressedData.length];
                [manager updateReceivedBytes:uncompressedData.length];
            });
            
            if ([[MMEReachability reachabilityForLocalWiFi] isReachableViaWiFi]) {
                it(@"should have wifiBytesSent increase count again", ^{
                    manager.metrics.wifiBytesSent should be_greater_than(0);
                    manager.metrics.wifiBytesReceived should be_greater_than(0);
                });
            } else {
                it(@"should have cellBytesSent increase count again", ^{
                    manager.metrics.cellBytesSent should be_greater_than(0);
                    manager.metrics.cellBytesReceived should be_greater_than(0);
                });
            }
            
            it(@"should have totalBytes increase count again", ^{
                manager.metrics.totalBytesSent should be_greater_than(0);
                manager.metrics.totalBytesReceived should be_greater_than(0);
            });
            
            context(@"when incrementing more data transfer metrics", ^{
                beforeEach(^{
                    [manager updateSentBytes:uncompressedData.length];
                    [manager updateReceivedBytes:uncompressedData.length];
                });
                
                if ([[MMEReachability reachabilityForLocalWiFi] isReachableViaWiFi]) {
                    it(@"should have wifiBytesSent increase count again", ^{
                        manager.metrics.wifiBytesSent should be_greater_than(300);
                        manager.metrics.wifiBytesReceived should be_greater_than(300);
                    });
                } else {
                    it(@"should have cellBytesSent increase count again", ^{
                        manager.metrics.cellBytesSent should be_greater_than(300);
                        manager.metrics.cellBytesReceived should be_greater_than(300);
                    });
                }
                
                it(@"should have totalBytesSent increase count again", ^{
                    manager.metrics.totalBytesSent should be_greater_than(400);
                    manager.metrics.totalBytesReceived should be_greater_than(400);
                });
            });
        });
        context(@"when incrementing appWakeUp counter", ^{
            beforeEach(^{
                [manager incrementAppWakeUpCount];
                [manager incrementAppWakeUpCount];
            });
            
            it(@"should have appWakeUp count increased", ^{
                manager.metrics.appWakeups should equal(2);
            });
        });
        context(@"when capturing configuration", ^{
            beforeEach(^{
                NSDictionary *configFake = [NSDictionary dictionaryWithObject:@"aniceconfig" forKey:@"anicekey"];
                
                [manager updateConfigurationJSON:configFake];
            });
            
            it(@"should have a configuration assigned", ^{
                manager.metrics.configResponseDict should_not be_nil;
            });
        });
        context(@"when capturing coordinates", ^{
            __block CLLocation *location;
            
            beforeEach(^{
                location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(38.644375, -77.289127) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0.0 timestamp:[NSDate date]];
                
                [manager updateCoordinate:location.coordinate];
            });
            
            it(@"should have less accurate values on deviceLat", ^{
                manager.metrics.deviceLat should be_less_than(location.coordinate.latitude);
            });
            
            it(@"should have less accurate values on deviceLon", ^{
                manager.metrics.deviceLon should be_greater_than(location.coordinate.longitude);
            });
        });
        context(@"when sending attributes", ^{
            it(@"should not be nil attributes", ^{
                [manager attributes] should_not be_nil;
            });
        });
        context(@"when storing an event from a future event version", ^{
            it(@"should encode event into memory and return nil when calling loadPendingTelemetryMetricsEvent", ^{
                MMEEventFake *futureVersionEvent = [MMEEventFake eventWithName:@"testName" attributes:@{@"aniceattribute":@"aniceattribute"}];
                
                NSString *pendingMetricFilePath = MMEMetricsManager.pendingMetricsEventPath;
                
                NSKeyedArchiver *archiver = [NSKeyedArchiver new];
                archiver.requiresSecureCoding = YES;
                [archiver encodeObject:futureVersionEvent forKey:NSKeyedArchiveRootObjectKey];
                
                [archiver.encodedData writeToFile:pendingMetricFilePath atomically:YES];
                
                [manager loadPendingTelemetryMetricsEvent] should be_nil;
            });
        });
    });
});

SPEC_END

