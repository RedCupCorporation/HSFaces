#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webView setBackgroundColor:[UIColor redColor]];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.hackerschool.com/private"] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:60];
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.frame = CGRectMake(360/2, 480/2, 40, 40);
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_spinner stopAnimating];
    NSLog(@"%@",[_webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
