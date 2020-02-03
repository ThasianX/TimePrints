#import <Foundation/Foundation.h>
#import "MMETypes.h"

NS_ASSUME_NONNULL_BEGIN

@class MMEEvent;

@interface MMEAPIClient : NSObject
/// Are we currently getting configuration updates?
@property (nonatomic, readonly) BOOL isGettingConfigUpdates;

- (instancetype)initWithAccessToken:(NSString *)accessToken userAgentBase:(NSString *)userAgentBase hostSDKVersion:(NSString *)hostSDKVersion;

// MARK: - Events Service

- (void)postEvents:(NSArray *)events completionHandler:(nullable void (^)(NSError * _Nullable error))completionHandler;
- (void)postEvent:(MMEEvent *)event completionHandler:(nullable void (^)(NSError * _Nullable error))completionHandler;
- (void)postMetadata:(NSArray *)metadata filePaths:(NSArray *)filePaths completionHandler:(nullable void (^)(NSError * _Nullable error))completionHandler;

// MARK: - Configuration Service

/// Start the Configuration update process
- (void)startGettingConfigUpdates;

/// Stop the Configuration update process
- (void)stopGettingConfigUpdates;

// MARK: - Deprecated

- (nullable NSError *)statusErrorFromRequest:(NSURLRequest *)request andHTTPResponse:(NSHTTPURLResponse *)httpResponse MME_DEPRECATED;

@end

NS_ASSUME_NONNULL_END
