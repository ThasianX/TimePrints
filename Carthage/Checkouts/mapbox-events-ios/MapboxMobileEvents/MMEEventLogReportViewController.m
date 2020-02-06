#import "MMEEventLogReportViewController.h"
#import "MMEConstants.h"

@interface MMEEventLogReportViewController () <WKUIDelegate, WKScriptMessageHandler>

@property UIActivityIndicatorView *spinner;
@property NSString *dataString;
@property NSUserActivity *activity;

@end

@implementation MMEEventLogReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, 80 + [UIApplication sharedApplication].statusBarFrame.size.height)];
    navBar.backgroundColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Profiler",nil)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed:)];
    navItem.rightBarButtonItem = shareButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    navItem.leftBarButtonItem = doneButton;
    
    [navBar setItems:@[navItem]];
    [self.view addSubview:navBar];
    navBar.layer.zPosition = 1;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
    view.layer.zPosition = -1;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    [controller addScriptMessageHandler:self name:@"complete"];
    [controller addScriptMessageHandler:self name:@"data"];
    configuration.userContentController = controller;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) configuration:configuration];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner setFrame:CGRectMake(self.view.frame.size.width/2 - self.spinner.frame.size.width/2, self.view.frame.size.height/2, self.spinner.frame.size.width, self.spinner.frame.size.height)];
    [self.view addSubview:self.spinner];
    
    [self.spinner startAnimating];
}

- (void)displayHTMLFromRowsWithDataString:(NSString *)dataString {
    self.dataString = dataString;
    [self.webView loadHTMLString:MMELoggerHTML baseURL:nil];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isEqualToString:@"complete"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
        });
    } else {
        if (self.dataString) {
            NSString *exec = [NSString stringWithFormat:@"addData(%@)",self.dataString];
            [self.webView evaluateJavaScript:exec completionHandler:nil];
        }
    }
}

- (void)shareButtonPressed:(id)sender {
    
    NSString *htmlString = [MMELoggerShareableHTML stringByReplacingOccurrencesOfString:@"rows: dataString" withString:[NSString stringWithFormat:@"rows: %@",self.dataString]];
    
    NSString *path = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                              inDomains:NSUserDomainMask] lastObject].path
                      stringByAppendingPathComponent:@"telemetryLog.html"];
    [htmlString writeToFile:path atomically:YES
                   encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    
    NSArray *items = @[fileURL];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
}

- (void)doneButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
}

@end

