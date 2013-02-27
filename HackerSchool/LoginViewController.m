#import "LoginViewController.h"
#import "BlockingViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <AFNetworking.h>
#import "Parser.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkForData];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.sitesLoaded = 0;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"Hacker School Faces";
}

- (IBAction)login:(id)sender {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];

    [self blockUI];
    NSURL *url = [NSURL URLWithString:@"https://www.hackerschool.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_usernameField.text, @"email", _passwordField.text, @"password", nil];
    [httpClient postPath:@"/sessions" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[operation.response.URL absoluteString] isEqualToString:@"https://www.hackerschool.com/private"]) {
            Parser *parser = [[Parser alloc] init];
            [parser parseData:responseObject];
            [self unblockUI];
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        } else {
            [self unblockUI];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Your password or email was incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self unblockUI];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"There was an error connecting to hacker school. Check your connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

#pragma - mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ((_logoImage.frame.origin.y) > 4) {
        [UIView animateWithDuration:0.3 animations:^{
            _logoImage.alpha = 0;
            _logoImage.frame = CGRectOffset(_logoImage.frame, 0, -100);
            _loginButtun.frame = CGRectOffset(_loginButtun.frame, 0, -90);
            _usernameField.frame = CGRectOffset(_usernameField.frame, 0, -90);
            _passwordField.frame = CGRectOffset(_passwordField.frame, 0, -90);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    if (_logoImage.frame.origin.y > 4) {
        [UIView animateWithDuration:0.3 animations:^{
            _logoImage.alpha = 1.0;
            _logoImage.frame = CGRectOffset(_logoImage.frame, 0, 100);
            _loginButtun.frame = CGRectOffset(_loginButtun.frame, 0, 90);
            _usernameField.frame = CGRectOffset(_usernameField.frame, 0, 90);
            _passwordField.frame = CGRectOffset(_passwordField.frame, 0, 90);
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
