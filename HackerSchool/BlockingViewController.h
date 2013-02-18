#import <UIKit/UIKit.h>

@interface BlockingViewController : UIView

@property (strong, nonatomic) UIActivityIndicatorView *spinner;

- (void)show;

@end
