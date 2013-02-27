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
    if (!_spinner) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.spinner startAnimating];
    }
    return _spinner;
}

- (void)drawRect:(CGRect)rect {
    self.frame = [[UIScreen mainScreen] applicationFrame];
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont systemFontOfSize:18];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor grayColor];
    }
    return _messageLabel;
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
