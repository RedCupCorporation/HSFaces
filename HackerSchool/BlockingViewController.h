#import <UIKit/UIKit.h>

@interface BlockingViewController : UIView

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) NSString *message;

- (id)initWithMessage:(NSString *)message;
- (void)show;

@end
