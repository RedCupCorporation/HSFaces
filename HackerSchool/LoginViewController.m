#import "LoginViewController.h"
#import "BlockingViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
    _usernameField.delegate = self;
    _passwordField.delegate = self;
    [self checkForData];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.hackerschool.com/private"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:request];
    _sitesLoaded = 0;
}

- (IBAction)login:(id)sender {
    [self textFieldDidEndEditing:_passwordField];
    [self textFieldDidEndEditing:_usernameField];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"email\").value=\"%@\";", _usernameField.text]];
    NSString *getPasswordBox = [NSString stringWithFormat:@"document.getElementById(\"password\").value=\"%@\";", _passwordField.text];
    [_webView stringByEvaluatingJavaScriptFromString:getPasswordBox];
    [_webView stringByEvaluatingJavaScriptFromString:@"$('input[name=commit]').removeAttr('disabled');"];
    [_webView stringByEvaluatingJavaScriptFromString:@"$('input[name=commit]').click();"];
}

#pragma - mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        _logoImage.alpha = 0;
        _logoImage.frame = CGRectOffset(_logoImage.frame, 0, -100);
        _loginButtun.frame = CGRectOffset(_loginButtun.frame, 0, -90);
        _usernameField.frame = CGRectOffset(_usernameField.frame, 0, -90);
        _passwordField.frame = CGRectOffset(_passwordField.frame, 0, -90);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _logoImage.alpha = 1.0;
        _logoImage.frame = CGRectOffset(_logoImage.frame, 0, 100);
        _loginButtun.frame = CGRectOffset(_loginButtun.frame, 0, 90);
        _usernameField.frame = CGRectOffset(_usernameField.frame, 0, 90);
        _passwordField.frame = CGRectOffset(_passwordField.frame, 0, 90);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma - mark WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"site started loading");
    [self blockUI];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"site finished loading");
    [self unblockUI];
    NSString *currentURL = webView.request.URL.absoluteString;
    if ([currentURL isEqualToString:@"https://www.hackerschool.com/sessions"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login error" message:@"Did you forget your username or password" delegate:self cancelButtonTitle:@"Maybe" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([currentURL isEqualToString:@"https://www.hackerschool.com/private"]) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

- (void)blockUI {
    _blockingView = [[BlockingViewController alloc] initWithMessage:@"Loading Hacker School Data.."];
    _blockingView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:_blockingView];
    [_blockingView show];
}

- (void)unblockUI {
    [_blockingView removeFromSuperview];
}

- (void)checkForData {
    NSManagedObjectContext *objectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *dataCheck = [[NSFetchRequest alloc] initWithEntityName:@"Batch"];
    NSArray *batches = [objectContext executeFetchRequest:dataCheck error:nil];
    if ([batches count] > 0) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

@end
