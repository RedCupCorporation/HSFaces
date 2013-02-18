#import "DisplayViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import <AFNetworking.h>

@interface DisplayViewController ()

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newStudentImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)newStudentImage {
    int num;
    do {
        num = arc4random() % [_batch.students count];
    } while (num == _lastGuess);
    _lastGuess = num;

    _currentStudent = [[_batch.students allObjects] objectAtIndex:num];
    NSString *requestString = [NSString stringWithFormat:@"http://www.hackerschool.com%@", _currentStudent.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    UIImage *image = [UIImage imageNamed:@"logo"];
    _imageView.alpha = 0.3;
    [_imageView setImageWithURLRequest:request placeholderImage:image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _imageView.alpha = 1.0;
        self.imageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        _imageView.alpha = 0.3;
    }];
}

- (void)handleTap {
    [self newStudentImage];
}

@end
