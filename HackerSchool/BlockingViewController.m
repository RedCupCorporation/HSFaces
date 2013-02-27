#import "BlockingViewController.h"

@interface BlockingViewController ()

@end

@implementation BlockingViewController

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    }
    return self;
}

- (id)initWithMessage:(NSString *)message {
    self = [self init];
    self.message = message;
    return self;
}

- (UIActivityIndicatorView *)spinner {
    if (!self.spinner) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.spinner startAnimating];
    }
    return self.spinner;
}

- (void)drawRect:(CGRect)rect {
    self.frame = [[UIScreen mainScreen] applicationFrame];
}

- (UILabel *)messageLabel {
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont systemFontOfSize:18];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.textColor = [UIColor grayColor];
    }
    return self.messageLabel;
}

- (void)layoutSubviews {
    CGPoint offset = self.center;
    offset.y = offset.y - 50;
    self.spinner.center = offset;
    self.messageLabel.frame = CGRectMake(10, CGRectGetMaxY(self.spinner.frame) + 10, 300, self.messageLabel.font.pointSize + 5);
}

- (void)show {
    [self.window makeKeyAndVisible];
    [self.window addSubview:self];
    [self addSubview:self.spinner];
    self.messageLabel.text = self.message;
    [self addSubview:self.messageLabel];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
    [self.spinner startAnimating];
}

@end
