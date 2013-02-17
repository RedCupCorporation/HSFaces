#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
    _usernameField.delegate = self;
    _passwordField.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.hackerschool.com/private"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:request];
    _sitesLoaded = 0;
}

- (IBAction)login:(id)sender {
//    NSString *username = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementByName(\"commit\");"];
//    NSLog(@"%@", username);
}

#pragma - mark TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _usernameField) {
        NSString *username = [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"email\").innerHTML=\"%@\";", _usernameField.text]];
        NSLog(@"%@", username);
    }

    if (textField == _passwordField) {
        NSString *test = [NSString stringWithFormat:@"document.getElementById(\"password\").innerHTML=\"%@\";", _passwordField.text];
        NSString *password = [_webView stringByEvaluatingJavaScriptFromString:test];
        NSLog(@"%@", password);
    }
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma - mark WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _spinner.frame = CGRectMake(360/2, 480/2, 40, 40);
//    [self.view addSubview:_spinner];
//    [_spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _sitesLoaded++;
    if (_sitesLoaded == 2) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
//    [self.fetchedResultsController performFetch:nil];
//    [self.tableView reloadData];
//    [_spinner stopAnimating];
}
@end
