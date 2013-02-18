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

- (UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_spinner startAnimating];
    }
    return _spinner;
}

- (void)drawRect:(CGRect)rect {
    self.frame = [[UIScreen mainScreen] applicationFrame];
}

- (void)layoutSubviews {
    self.spinner.center = self.center;
}

- (void)show {
    [self.window makeKeyAndVisible];
    [self.window addSubview:self];
    [self addSubview:self.spinner];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
    [self.spinner startAnimating];
}

@end
