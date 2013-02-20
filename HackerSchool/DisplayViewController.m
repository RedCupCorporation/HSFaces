#import "DisplayViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import <AFNetworking.h>

@interface DisplayViewController ()

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    _students = [[_batch.students allObjects] mutableCopy];
    _score = 0;
    _guesses = 0;
    _guessTextbox.autocorrectionType = UITextAutocorrectionTypeNo;
    _guessButton.enabled = NO;
    [_guessTextbox addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventAllEditingEvents];
    [_guessTextbox becomeFirstResponder];
    [self newStudentImage];
    self.title = @"Hacker School Faces";
}

- (void)setupViews {
    if ([[UIScreen mainScreen] bounds].size.height > 500) {
        _submitFormView.frame = CGRectOffset(_submitFormView.frame, 0, 87);
        _imageView.frame = CGRectInset(_imageView.frame, -20, -20);
        _imageView.frame = CGRectMake(CGRectGetMinX(_imageView.frame)-10, CGRectGetMinY(_imageView.frame)+20, CGRectGetWidth(_imageView.frame)+20, CGRectGetHeight(_imageView.frame)+20);
    }
}

- (void)guessSequence {
    if ([self guessName]) {
        _score++;
        _guesses++;
        [self nextGuess];
    } else {
        _guesses++;
        [self displayError];
        _guessButton.enabled = NO;
        [self performSelector:@selector(removeError) withObject:nil afterDelay:1.0];
    }
}

- (void)nextGuess {
    [self removeStudent];
    _guessTextbox.text = @"";
    [self textChanged];
    if ([_students count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You scored %d out of %d", _score, _guesses] message:@"Nice Work!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self newStudentImage];
}

- (void)removeStudent {
    [_students removeObject:_currentStudent];
}

- (BOOL)guessName {
    NSArray *parts = [_currentStudent.name componentsSeparatedByString:@" "];
    if ([[_guessTextbox.text lowercaseString] isEqualToString:[[parts objectAtIndex:0] lowercaseString]] || [[_guessTextbox.text lowercaseString] isEqualToString:[_currentStudent.name lowercaseString]] ) {
        return YES;
    } else {
        return NO;
    }
}

- (void)removeError {
    _imageView.alpha = 1.0;
    [_warning removeFromSuperview];
    _guessButton.enabled = YES;
    [self nextGuess];
}

- (void)displayError {
    NSString *name = [[_currentStudent.name componentsSeparatedByString:@" "] objectAtIndex:0];

    _warning = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_imageView.frame), CGRectGetMaxY(_imageView.frame), 200, 50)];
    _warning.numberOfLines = 0;
    _warning.textAlignment = NSTextAlignmentCenter;
    _warning.text = [NSString stringWithFormat:@"Uhoh.. that was %@", name];
    _warning.backgroundColor = [UIColor clearColor];
    _warning.font = [UIFont systemFontOfSize:50];
    _warning.textColor = [UIColor redColor];
    [self.view addSubview:_warning];

    [UIView animateWithDuration:0.1 animations:^{
        _imageView.alpha = 0.5;
        _warning.frame = CGRectMake(CGRectGetMinX(_imageView.frame)-50, CGRectGetMaxY(_imageView.frame)-100, 200, 100);
        _warning.font = [UIFont boldSystemFontOfSize:25];
        _warning.transform = CGAffineTransformMakeRotation(-0.6);
    }];
}

- (IBAction)submit:(id)sender {
    [self guessSequence];
}

- (void)newStudentImage {
    NSUInteger num;
    do {
        num = arc4random_uniform([_students count]+1);
        if (!(num == 0)) {
            num -=1;
        }
    } while (num == _lastGuess && [_students count] > 1);

    _currentStudent = [_students objectAtIndex:num];
    _lastGuess = num;
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
    if ([_guessTextbox.text length] == 0) {
        return;
    }
    [self guessSequence];
}

- (void)textChanged {
    if ([_guessTextbox.text length] > 0) {
        _guessButton.enabled = YES;
    } else {
        _guessButton.enabled = NO;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController  popViewControllerAnimated:YES];
}

@end
