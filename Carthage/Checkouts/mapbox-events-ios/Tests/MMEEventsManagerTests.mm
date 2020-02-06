@import Cedar;

#import "MMEEvent.h"
#import "MMEEventsManager.h"
#import "MMEConstants.h"
#import "MMEUniqueIdentifier.h"
#import "MMEDate.h"
#import "MMELocationManager.h"
#import "MMEAPIClient.h"
#import "MMEAPIClient_Private.h"
#import "MMETimerManager.h"
#import "MMEDispatchManagerFake.h"
#import "MMETimerManagerFake.h"
#import "MMEAPIClientFake.h"
#import "MMECommonEventData.h"
#import "MMEUIApplicationWrapperFake.h"
#import "MMEUIApplicationWrapper.h"
#import "MMEMetricsManager.h"
#import "MMEDateFakes.h"
#import "MMEBundleInfoFake.h"

#import "CLLocation+MMEMobileEvents.h"
#import "CLLocationManager+MMEMobileEvents.h"
#import "NSUserDefaults+MMEConfiguration.h"
#import "NSUserDefaults+MMEConfiguration_Private.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;
using namespace Cedar::Doubles::Arguments;

@interface MMEEventsManager (Tests) <MMELocationManagerDelegate>

@property (nonatomic) NS_MUTABLE_ARRAY_OF(MMEEvent *) *eventQueue;
@property (nonatomic, getter=isPaused) BOOL paused;
@property (nonatomic) MMECommonEventData *commonEventData;
@property (nonatomic) id<MMELocationManager> locationManager;
@property (nonatomic) id<MMEAPIClient> apiClient;
@property (nonatomic) id<MMEUniqueIdentifer> uniqueIdentifer;
@property (nonatomic) MMETimerManager *timerManager;
@property (nonatomic) MMEDispatchManager *dispatchManager;
@property (nonatomic) NSDate *nextTurnstileSendDate;
@property (nonatomic) id<MMEUIApplicationWrapper> application;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

- (instancetype)initShared;
- (void)pushEvent:(MMEEvent *)event;

@end

#pragma mark -

@interface MMEEvent (Tests)
@property(nonatomic) MMEDate *dateStorage;
@property(nonatomic) NSDictionary *attributesStorage;

@end

#pragma mark -

SPEC_BEGIN(MMEEventsManagerSpec)

/* many of the tests use a manager which is not the shared manager,
   in normal operation clietns should not use the private initShared method used for testsing */
describe(@"MMEventsManager.sharedManager", ^{
    MMEEventsManager *shared = MMEEventsManager.sharedManager;
    MMEEventsManager *allocated = [MMEEventsManager.alloc init];

    it(@"should equal the allocated manager", ^{
        shared should equal(allocated);
    });
});

describe(@"MMEEventsManager", ^{
    
    __block MMEEventsManager *eventsManager;
    __block MMEDispatchManagerFake *dispatchManager;

    beforeEach(^{
        dispatchManager = [[MMEDispatchManagerFake alloc] init];
        eventsManager = [MMEEventsManager.alloc initShared];

        eventsManager.dispatchManager = dispatchManager;
        eventsManager.locationManager = nice_fake_for(@protocol(MMELocationManager));

        [eventsManager.eventQueue removeAllObjects];

        // set a high MMEEventFlushCount to prevent crossing the threshold in the tests
        [NSUserDefaults.mme_configuration setObject:@1000 forKey:MMEEventFlushCount];
    });

    it(@"sets common event data", ^{
        eventsManager.commonEventData should_not be_nil;
    });

    describe(@"-initializeWithAccessToken:userAgentBase:hostSDKVersion:", ^{
        context(@"when the custom events profile is set", ^{
            beforeEach(^{
                NSBundle.mme_mainBundle = [MMEBundleInfoFake bundleWithFakeInfo:@{
                    MMEEventsProfile : MMECustomProfile,
                    MMEStartupDelay: @10,
                    MMECustomGeofenceRadius: @1200
                }];
                [NSUserDefaults.mme_configuration mme_registerDefaults];
                
                eventsManager = [MMEEventsManager.alloc initShared];
                eventsManager.dispatchManager = dispatchManager;
                [eventsManager initializeWithAccessToken:@"foo" userAgentBase:@"bar" hostSDKVersion:@"baz"];
            });
            
            it(@"should schedule the initialization work with a 10 second delay", ^{
                dispatchManager.delay should equal(10);
            });

            it(@"should set the sttartup delay to a 10 second delay", ^{
                NSUserDefaults.mme_configuration.mme_startupDelay should equal(10);
            });
            
            it(@"should allow for custom geofence radius", ^{
                NSUserDefaults.mme_configuration.mme_backgroundGeofence should equal(1200);
            });
        });
    
        context(@"when the custom events profile is set over the max values allowed", ^{
            beforeEach(^{
                NSBundle.mme_mainBundle = [MMEBundleInfoFake bundleWithFakeInfo:@{
                    MMEEventsProfile: MMECustomProfile,
                    MMEStartupDelay : @9001,
                    MMECustomGeofenceRadius: @9001
                }];
                [NSUserDefaults.mme_configuration mme_registerDefaults];

                eventsManager = [MMEEventsManager.alloc initShared];
                eventsManager.dispatchManager = dispatchManager;
                [eventsManager initializeWithAccessToken:@"foo" userAgentBase:@"bar" hostSDKVersion:@"baz"];
            });

            it(@"should schedule the initialization work with a 1 second delay", ^{
                dispatchManager.delay should equal(1);
            });
            
            it(@"should revert the sttartup delay to default 1 second delay", ^{
                NSUserDefaults.mme_configuration.mme_startupDelay should equal(1);
            });
            
            it(@"should revert custom geofence radius to default", ^{
                NSUserDefaults.mme_configuration.mme_backgroundGeofence should equal(300);
            });
        });
    
        context(@"when the custom events profile is set under the minimum values allowed", ^{
            beforeEach(^{
                NSBundle.mme_mainBundle = [MMEBundleInfoFake bundleWithFakeInfo:@{
                    MMEEventsProfile: MMECustomProfile,
                    MMEStartupDelay: @-42,
                    MMECustomGeofenceRadius : @9
                }];
                [NSUserDefaults.mme_configuration mme_registerDefaults];

                eventsManager = [MMEEventsManager.alloc initShared];
                eventsManager.dispatchManager = dispatchManager;
                [eventsManager initializeWithAccessToken:@"foo" userAgentBase:@"bar" hostSDKVersion:@"baz"];
            });
            
            it(@"should have the default startup delay", ^{
                NSUserDefaults.mme_configuration.mme_startupDelay should equal(1);
            });
        });

        context(@"when no fancy value is set", ^{
            beforeEach(^{
                NSBundle.mme_mainBundle = nil;
                [NSUserDefaults.mme_configuration mme_registerDefaults];

                eventsManager = [MMEEventsManager.alloc initShared];
                eventsManager.dispatchManager = dispatchManager;
                [eventsManager initializeWithAccessToken:@"foo" userAgentBase:@"bar" hostSDKVersion:@"baz"];
            });
            
            it(@"should schedule the initialization work with a 1 second delay", ^{
                dispatchManager.delay should equal(1);
            });

            it(@"should revert the sttartup delay to default 1 second delay", ^{
                NSUserDefaults.mme_configuration.mme_startupDelay should equal(1);
            });
            
            it(@"should revert custom geofence radius to default", ^{
                NSUserDefaults.mme_configuration.mme_backgroundGeofence should equal(300);
            });
        });

        context(@"when no profile is set", ^{
            beforeEach(^{
                NSBundle.mme_mainBundle = nil;
                [NSUserDefaults.mme_configuration mme_registerDefaults];

                eventsManager = [MMEEventsManager.alloc initShared];
                eventsManager.dispatchManager = dispatchManager;
                
                [eventsManager initializeWithAccessToken:@"foo" userAgentBase:@"bar" hostSDKVersion:@"baz"];
            });

            it(@"should schedule the initialization work with a 1 second delay", ^{
                dispatchManager.delay should equal(1);
            });
            
            it(@"should revert the sttartup delay to default 1 second delay", ^{
                NSUserDefaults.mme_configuration.mme_startupDelay should equal(1);
            });
            
            it(@"should revert custom geofence radius to default", ^{
                NSUserDefaults.mme_configuration.mme_backgroundGeofence should equal(300);
            });
        });
    });
    
    describe(@"- setSkuId", ^{
        __block NSString *aNiceSkuId = @"42";
        
        beforeEach(^{
            [eventsManager initializeWithAccessToken:@"access-token" userAgentBase:@"user-agent-base" hostSDKVersion:@"host-version"];
        });
        
        it(@"shouldn't be set", ^{
            eventsManager.skuId should be_nil;
        });
        
        it(@"sets the skuId on the events manager", ^{
            [eventsManager setSkuId:aNiceSkuId];
            
            eventsManager.skuId should equal(aNiceSkuId);
        });
    });
    
    describe(@"- flush", ^{
        
        beforeEach(^{
            id<MMEAPIClient> apiClient = nice_fake_for(@protocol(MMEAPIClient));
            eventsManager.apiClient = apiClient;
        });
        
        context(@"when the events manager is paused", ^{
            beforeEach(^{
                eventsManager.paused = YES;
            });
            
            it(@"does not tell the api client to post events", ^{
                eventsManager.apiClient should_not have_received(@selector(postEvents:completionHandler:));
            });
        });
        
        context(@"when the events manager is not paused", ^{
            beforeEach(^{
                eventsManager.paused = NO;
            });
            
            context(@"when no access token has been set", ^{
                beforeEach(^{
                    [NSUserDefaults.mme_configuration mme_deleteObjectForVolatileKey:MMEAccessToken];
                    [eventsManager flush];
                });
                
                it(@"does NOT tell the api client to post events", ^{
                    eventsManager.apiClient should_not have_received(@selector(postEvents:completionHandler:));
                });
            });
            
            context(@"when an access token has been set", ^{
                beforeEach(^{
                    NSUserDefaults.mme_configuration.mme_accessToken = @"access-token";
                });
                
                context(@"when there are no events in the queue", ^{
                    beforeEach(^{
                        eventsManager.eventQueue.count should equal(0);
                        [eventsManager flush];
                    });
                    
                    it(@"does NOT tell the api client to post events", ^{
                        eventsManager.apiClient should_not have_received(@selector(postEvents:completionHandler:));
                    });
                });
                
                context(@"when there are events in the queue", ^{
                    beforeEach(^{
                        eventsManager.timerManager = [[MMETimerManager alloc] initWithTimeInterval:1000 target:eventsManager selector:@selector(flush)];
                        spy_on(eventsManager.timerManager);
                        [eventsManager enqueueEventWithName:MMEEventTypeMapLoad];
                        [eventsManager flush];
                    });
                    
                    it(@"tells the api client to post events", ^{
                        eventsManager.apiClient should have_received(@selector(postEvents:completionHandler:));
                    });
                    
                    it(@"tells its timer manager to cancel", ^{
                        eventsManager.timerManager should have_received(@selector(cancel));
                    });
                    
                    it(@"does nothing if flush is called again", ^{
                        [(id<CedarDouble>)eventsManager.apiClient reset_sent_messages];
                        [eventsManager flush];
                        eventsManager.apiClient should_not have_received(@selector(postEvents:completionHandler:));
                    });
                });
            });
        });
        
    });
    
    describe(@"- sendTurnstileEvent", ^{
        
        context(@"when next turnstile send date is nil", ^{
            beforeEach(^{
                eventsManager.nextTurnstileSendDate should be_nil;
            });
            
            describe(@"calling the method before setting up required variables", ^{
                beforeEach(^{
                    MMEAPIClientFake *fakeAPIClient = [[MMEAPIClientFake alloc] init];
                    spy_on(fakeAPIClient);
                    
                    NSUserDefaults.mme_configuration.mme_accessToken = @"access-token";
                    NSUserDefaults.mme_configuration.mme_legacyUserAgentBase = @"user-agent-base";
                    NSUserDefaults.mme_configuration.mme_legacyHostSDKVersion = @"host-sdk-version";
                    
                    eventsManager.apiClient = fakeAPIClient;
                    
                    MMECommonEventData *commonEventData = [[MMECommonEventData alloc] init];
                    spy_on(commonEventData);
                    commonEventData.vendorId = @"vendor-id";
                    commonEventData.model = @"model";
                    commonEventData.osVersion = @"ios-version";
                    
                    eventsManager.commonEventData = commonEventData;
                });
                
                context(@"when the events manager's api client does not have an access token set", ^{
                    beforeEach(^{
                        [NSUserDefaults.mme_configuration mme_deleteObjectForVolatileKey:MMEAccessToken];
                        [eventsManager sendTurnstileEvent];
                    });
                    
                    it(@"does not tell its api client to post the event", ^{
                        eventsManager.apiClient should_not have_received(@selector(postEvent:completionHandler:));
                    });
                });
                
                context(@"when the events manager's api client does not have a user agent base set", ^{
                    beforeEach(^{
                        [NSUserDefaults.mme_configuration mme_deleteObjectForVolatileKey:MMELegacyUserAgentBase];
                        [NSUserDefaults.mme_configuration mme_deleteObjectForVolatileKey:MMELegacyUserAgent];
                        [eventsManager sendTurnstileEvent];
                    });
                    
                    it(@"does not tell its api client to post the event", ^{
                        eventsManager.apiClient should_not have_received(@selector(postEvent:completionHandler:));
                    });
                });
                
                context(@"when the events manager's api client does not have a host sdk version set", ^{
                    beforeEach(^{
                        [NSUserDefaults.mme_configuration mme_deleteObjectForVolatileKey:MMELegacyHostSDKVersion];
                        [eventsManager sendTurnstileEvent];
                    });
                    
                    it(@"does not tell its api client to post the event", ^{
                        eventsManager.apiClient should_not have_received(@selector(postEvent:completionHandler:));
                    });
                });
                
                context(@"when the events manager's common even data does not have a vendor id", ^{
                    beforeEach(^{
                        eventsManager.commonEventData stub_method(@selector(vendorId)).and_return(nil);
                        [eventsManager sendTurnstileEvent];
                    });
                    
                    it(@"does not tell its api client to post the event", ^{
                        eventsManager.apiClient should_not have_received(@selector(postEvent:completionHandler:));
                    });
                });
                
                context(@"when the events manager's common even data does not have a model", ^{
                    beforeEach(^{
                        eventsManager.commonEventData stub_method(@selector(model)).and_return(nil);
                        [eventsManager sendTurnstileEvent];
                    });
                    
                    it(@"does not tell its api client to post the event", ^{
                        eventsManager.apiClient should_not have_received(@selector(postEvent:completionHandler:));
                    });
                });
                
                context(@"when the events manager's common even data does not have a ios version", ^{
                    beforeEach(^{
                        eventsManager.commonEventData stub_method(@selector(osVersion)).and_return(nil);
                        [eventsManager sendTurnstileEvent];
                    });
                    
                    it(@"does not tell its api client to post the event", ^{
                        eventsManager.apiClient should_not have_received(@selector(postEvent:completionHandler:));
                    });
                });
            });
        });
    });
    
    describe(@"- sendTelemetryMetricsEvent", ^{
        context(@"when next telemetryMetrics send date is not nil and event manager is correctly configured", ^{
            beforeEach(^{
                MMEEvent *event = [MMEEvent mapTapEventWithDateString:@"a nice date" attributes:@{@"attribute1": @"a nice attribute"}];
                NSArray *eventQueueFake = [[NSArray alloc] initWithObjects:event, nil];
                eventsManager.eventQueue = [eventQueueFake mutableCopy];
                [eventsManager flush];
                
                MMEAPIClientFake *fakeAPIClient = [[MMEAPIClientFake alloc] init];
                spy_on(fakeAPIClient);
                eventsManager.apiClient = fakeAPIClient;
                
                NSUserDefaults.mme_configuration.mme_accessToken = @"access-token";
                NSUserDefaults.mme_configuration.mme_legacyUserAgentBase = @"user-agent-base";
                NSUserDefaults.mme_configuration.mme_legacyHostSDKVersion = @"host-sdk-version";
                
                spy_on([MMEMetricsManager sharedManager].metrics);
            });
            
            afterEach(^{
                stop_spying_on([MMEMetricsManager sharedManager].metrics);
            });
            
            context(@"when the current time is before the next telemetryMetrics send date", ^{
                beforeEach(^{
                    [MMEMetricsManager sharedManager].metrics stub_method(@selector(recordingStarted)).and_return(NSDate.distantFuture);
                    
                    [eventsManager sendTelemetryMetricsEvent];
                });
                
                it(@"tells its api client to not post events", ^{
                    eventsManager.apiClient should_not have_received(@selector(postEvent:completionHandler:));
                });
            });
            
            context(@"when the current time is after the next telemetryMetrics send date", ^{
                beforeEach(^{
                    [MMEMetricsManager sharedManager].metrics stub_method(@selector(recordingStarted)).and_return(NSDate.distantPast);
                    [eventsManager sendTelemetryMetricsEvent];
                });
                
                it(@"tells its api client to post events", ^{
                    eventsManager.apiClient should have_received(@selector(postEvent:completionHandler:));
                });
            });
        });
    });
    
    describe(@"- enqueueEventWithName:attributes", ^{
        __block NSString *dateString;
        __block MMECommonEventData *commonEventData;
        __block NSDictionary *attributes;
        
        beforeEach(^{
            dateString = @"A nice date";
            NSDateFormatter *dateFormatter = MMEDate.iso8601DateFormatter;
            spy_on(dateFormatter);
            dateFormatter stub_method(@selector(stringFromDate:)).and_return(dateString);
            commonEventData = [[MMECommonEventData alloc] init];
            commonEventData.vendorId = @"a nice vendor id";
            commonEventData.model = @"a nice model";
            commonEventData.osVersion = @"a nice ios version";
            commonEventData.scale = 42.0;
            eventsManager.commonEventData = commonEventData;
            
            attributes = @{@"attribute1": @"a nice attribute"};
        });
        
        context(@"when the events manager is not paused", ^{
            beforeEach(^{
                eventsManager.paused = NO;
            });
            
            context(@"when a map tap event is pushed", ^{
                beforeEach(^{
                    [eventsManager enqueueEventWithName:MMEEventTypeMapTap attributes:attributes];
                });
                
                it(@"has the correct event", ^{
                    MMEEvent *expectedEvent = [MMEEvent mapTapEventWithDateString:dateString attributes:attributes];
                    MMEEvent *event = eventsManager.eventQueue.firstObject;
                    expectedEvent.dateStorage = event.dateStorage;

                    event should equal(expectedEvent);
                });
            });

            context(@"when a map drag end event is pushed", ^{
                beforeEach(^{
                    [eventsManager enqueueEventWithName:MMEEventTypeMapDragEnd attributes:attributes];
                });
                
                it(@"has the correct event", ^{
                    MMEEvent *expectedEvent = [MMEEvent mapDragEndEventWithDateString:dateString attributes:attributes];
                    MMEEvent *event = eventsManager.eventQueue.firstObject;
                    expectedEvent.dateStorage = [MMEDate dateWithDate:event.date];

                    event should equal(expectedEvent);
                });
            });
            
            context(@"when a map download start event is pushed", ^{
                beforeEach(^{
                    [eventsManager enqueueEventWithName:MMEventTypeOfflineDownloadStart attributes:attributes];
                });
                
                it(@"has the correct event", ^{
                    MMEEvent *expectedEvent = [MMEEvent mapOfflineDownloadStartEventWithDateString:dateString attributes:attributes];
                    MMEEvent *event = eventsManager.eventQueue.firstObject;
                    expectedEvent.dateStorage = [MMEDate dateWithDate:event.date];

                    event should equal(expectedEvent);
                });
            });
            
            context(@"when a map download end event is pushed", ^{
                beforeEach(^{
                    [eventsManager enqueueEventWithName:MMEventTypeOfflineDownloadEnd attributes:attributes];
                });
                
                it(@"has the correct event", ^{
                    MMEEvent *expectedEvent = [MMEEvent mapOfflineDownloadEndEventWithDateString:dateString attributes:attributes];
                    MMEEvent *event = eventsManager.eventQueue.firstObject;
                    expectedEvent.dateStorage = [MMEDate dateWithDate:event.date];

                    event should equal(expectedEvent);
                });
            });
            
            context(@"when a navigation event is pushed", ^{
                __block NSString * navigationEventName = @"navigation.*";
                
                beforeEach(^{
                    [eventsManager enqueueEventWithName:navigationEventName attributes:attributes];
                });
                
                it(@"has the correct event", ^{
                    MMEEvent *expectedEvent = [MMEEvent navigationEventWithName:navigationEventName attributes:attributes];
                    MMEEvent *event = eventsManager.eventQueue.firstObject;
                    expectedEvent.dateStorage = event.dateStorage;

                    event should equal(expectedEvent);
                });
            });
            
            context(@"when a vision event is pushed", ^{
                __block NSString * visionEventName = @"vision.*";
                
                beforeEach(^{
                    [eventsManager enqueueEventWithName:visionEventName attributes:attributes];
                });
                
                it(@"has the correct event", ^{
                    MMEEvent *expectedEvent = [MMEEvent visionEventWithName:visionEventName attributes:attributes];
                    MMEEvent *event = eventsManager.eventQueue.firstObject;
                    expectedEvent.dateStorage = event.dateStorage;

                    event should equal(expectedEvent);
                });
            });
            
            context(@"when a search event is pushed", ^{
                __block NSString * searchEventName = @"search.*";
                
                beforeEach(^{
                    [eventsManager enqueueEventWithName:searchEventName attributes:attributes];
                });
                
                it(@"has the correct event", ^{
                    MMEEvent *expectedEvent = [MMEEvent searchEventWithName:searchEventName attributes:attributes];
                    MMEEvent *event = eventsManager.eventQueue.firstObject;
                    expectedEvent.dateStorage = event.dateStorage;

                    event should equal(expectedEvent);
                });
            });
            
            context(@"when a generic event is pushed", ^{
                beforeEach(^{
                    [eventsManager enqueueEventWithName:@"generic" attributes:attributes];
                });
                
                it(@"does queue the event", ^{
                    eventsManager.eventQueue.count should equal(1);
                });
            });
        });
    });
    
    describe(@"- enqueueEventWithName:", ^{
        __block NSString *dateString;
        __block MMECommonEventData *commonEventData;
        
        beforeEach(^{
            dateString = @"A nice date";
            NSDateFormatter *dateFormatter = MMEDate.iso8601DateFormatter;
            spy_on(dateFormatter);
            dateFormatter stub_method(@selector(stringFromDate:)).and_return(dateString);
            commonEventData = [[MMECommonEventData alloc] init];
            commonEventData.vendorId = @"a nice vendor id";
            commonEventData.model = @"a nice model";
            commonEventData.osVersion = @"a nice ios version";
            commonEventData.scale = 42.0;
            eventsManager.commonEventData = commonEventData;
        });
        
        context(@"when the events manager is not paused", ^{
            beforeEach(^{
                eventsManager.paused = NO;
            });
            
            context(@"when a map load event is pushed", ^{
                beforeEach(^{
                    [eventsManager enqueueEventWithName:MMEEventTypeMapLoad];
                });
                
                it(@"has the correct event", ^{
                    MMEEvent *expectedEvent = [MMEEvent mapLoadEventWithDateString:dateString commonEventData:commonEventData];
                    MMEEvent *event = eventsManager.eventQueue.firstObject;
                    expectedEvent.dateStorage = event.dateStorage;

                    event should equal(expectedEvent);
                });
            });
        });
        
        context(@"when the events manager is paused", ^{
            beforeEach(^{
                eventsManager.paused = YES;
            });
            
            context(@"when a map load event is pushed", ^{
                beforeEach(^{
                    [eventsManager enqueueEventWithName:MMEEventTypeMapLoad];
                });
                
                it(@"should queue events", ^{
                    eventsManager.eventQueue.count should equal(1);
                });
            });
        });
    });

    describe(@"- pushEvent:", ^{
        beforeEach(^{
            eventsManager.paused = YES;
        });

        context(@"when an error event is pushed", ^{
            NSError* testError = [NSError.alloc initWithDomain:NSCocoaErrorDomain code:999 userInfo:@{
                NSLocalizedDescriptionKey: @"Test Error Description",
                NSLocalizedFailureReasonErrorKey: @"Test Error Failure Reason"
            }];

            it(@"should not queue error events", ^{
                [MMEEventsManager.sharedManager pushEvent:[MMEEvent debugEventWithError:testError]];
                eventsManager.eventQueue.count should equal(0);
            });
        });

        context(@"when an exception event is pushed", ^{
            NSException* testException = [NSException.alloc initWithName:@"TestExceptionName" reason:@"TestExceptionReason" userInfo:nil];

            it(@"should not queue exception events", ^{
                [MMEEventsManager.sharedManager pushEvent:[MMEEvent debugEventWithException:testException]];
                eventsManager.eventQueue.count should equal(0);
            });
        });
    });

    describe(@"MMELocationManagerDelegate", ^{
        
        context(@"-[MMEEventsManager locatizonManager:didVisit:]", ^{
            __block CLVisit *visit;
            
            beforeEach(^{
                eventsManager.delegate = nice_fake_for(@protocol(MMEEventsManagerDelegate));
                eventsManager.paused = NO;
                
                visit = [[CLVisit alloc] init];
                spy_on(visit);
                
                CLLocationCoordinate2D coordinate = {10.0, -10.0};
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
                
                visit stub_method(@selector(coordinate)).and_return(coordinate);
                visit stub_method(@selector(arrivalDate)).and_return(date);
                visit stub_method(@selector(departureDate)).and_return(date);
                visit stub_method(@selector(horizontalAccuracy)).and_return(42.0);
                
                [eventsManager locationManager:eventsManager.locationManager didVisit:visit];
            });
            
            it(@"enqueues the correct event", ^{
                CLLocation *location = [[CLLocation alloc] initWithLatitude:visit.coordinate.latitude longitude:visit.coordinate.longitude];
                NSDictionary *attributes = @{
                    MMEEventKeyCreated: [MMEDate.iso8601DateFormatter stringFromDate:[location timestamp]],
                    MMEEventKeyLatitude: @([location mme_latitudeRoundedWithPrecision:7]),
                    MMEEventKeyLongitude: @([location mme_longitudeRoundedWithPrecision:7]),
                    MMEEventHorizontalAccuracy: @(visit.horizontalAccuracy),
                    MMEEventKeyArrivalDate: [MMEDate.iso8601DateFormatter stringFromDate:visit.arrivalDate],
                    MMEEventKeyDepartureDate: [MMEDate.iso8601DateFormatter stringFromDate:visit.departureDate]
                };
                MMEEvent *expectedVisitEvent = [MMEEvent visitEventWithAttributes:attributes];
                MMEEvent *enqueueEvent = eventsManager.eventQueue.firstObject;

                expectedVisitEvent.dateStorage = enqueueEvent.dateStorage;

                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict addEntriesFromDictionary:enqueueEvent.attributes];
                [tempDict setObject:[MMEDate.iso8601DateFormatter stringFromDate:[location timestamp]] forKey:@"created"];
                enqueueEvent.attributesStorage = tempDict;
                
                enqueueEvent should equal(expectedVisitEvent);
            });
            
            it(@"tells its delegate", ^{
                eventsManager.delegate should have_received(@selector(eventsManager:didVisit:)).with(eventsManager, visit);
            });
        });
    });
});

SPEC_END
