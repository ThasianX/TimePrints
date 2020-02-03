#import "MMETestStub.h"
#import "MMEAPIClient.h"
#import "MMEAPIClient_Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMEAPIClientFake : MMETestStub <MMEAPIClient>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *userAgentBase;
@property (nonatomic, copy) NSString *hostSDKVersion;

@property (nonatomic, nullable) void (^callingCompletionHandler)(NSError * _Nullable error);
@property (nonatomic, nullable) void (^callingDataCompletionHandler)(NSError * _Nullable error, NSData * _Nullable data);

- (void)completePostingEventsWithError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
