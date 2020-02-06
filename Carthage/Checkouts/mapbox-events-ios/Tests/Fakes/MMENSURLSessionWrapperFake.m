#import "MMENSURLSessionWrapperFake.h"

@implementation MMENSURLSessionWrapperFake

- (void)processRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    [self store:_cmd args:@[request, completionHandler]];

    self.request = request;
    self.callingCompletionHandler = completionHandler;
}

- (void)completeProcessingWithData:(NSData * _Nullable)data response:(NSURLResponse * _Nullable)response error:(NSError * _Nullable)error {
    if (self.callingCompletionHandler) {
        self.callingCompletionHandler(data, response, error);
    }
}

@end
