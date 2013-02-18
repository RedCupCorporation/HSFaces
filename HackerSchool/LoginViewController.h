#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButtun;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)login:(id)sender;
@property (nonatomic) int sitesLoaded;

@end
