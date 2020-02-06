#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MMEEventLogReportViewController : UIViewController

@property (nonatomic) WKWebView *webView;

- (void)displayHTMLFromRowsWithDataString:(NSString *)dataString;

@end

