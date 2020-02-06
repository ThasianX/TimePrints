#import <Foundation/Foundation.h>

@class MMEEventsConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface MMECertPin : NSObject

- (void)handleChallenge:(NSURLAuthenticationChallenge * _Nonnull)challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;

@end

NS_ASSUME_NONNULL_END
