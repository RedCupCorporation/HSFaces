#import "DisplayViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import <AFNetworking.h>

NSString *const HIGH_SCORE_MESSAGE = @"Nice Work!";
NSString *const MEDIUM_SCORE_MESSAGE = @"Your getting there!";
NSString *const LOW_SCORE_MESSAGE = @"I think you need a little more practice.";
NSString *const VERY_LOW_SCORE_MESSAGE = @"Uh..oh I hope your new here.";

@interface DisplayViewController ()

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    _objectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    _students = [[_batch.students allObjects] mutableCopy];
    _score = 0;
    _guesses = 0;
    _guessButton.enabled = NO;
    _guessTextbox.delegate = self;
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
        [self displayCorrect];
        _score++;
        _guesses++;
    } else {
        _guesses++;
        [self displayError];
        _guessButton.enabled = NO;
    }
    [self performSelector:@selector(nextGuess) withObject:nil afterDelay:1.0];
}

- (void)nextGuess {
    [_warning removeFromSuperview];
    [_correctImage removeFromSuperview];
    [self removeStudent];
    _guessTextbox.text = @"";
    [self textChanged];
    if ([_students count] == 0) {
        NSString *message;
        float percentage = (float)_score / _guesses;
        if (percentage > 0.95) {
            message = HIGH_SCORE_MESSAGE;
        } else if (percentage > 0.75) {
            message = MEDIUM_SCORE_MESSAGE;
        } else if (percentage > 0.30) {
            message = LOW_SCORE_MESSAGE;
        } else {
            message = VERY_LOW_SCORE_MESSAGE;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You scored %d out of %d", _score, _guesses] message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

- (void)displayCorrect {
    _correctImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 200, 200)];
    _correctImage.image = [UIImage imageNamed:@"correct@2x.png"];
    [self.view addSubview:_correctImage];
    [UIView animateWithDuration:0.15 animations:^{
        _correctImage.frame = CGRectInset(_imageView.frame, 10, 10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _correctImage.frame = _imageView.frame;
        }];
    }];
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

    if (_currentStudent.image) {
        UIImage *image = [UIImage imageWithData:_currentStudent.image];
        _imageView.image = image;
    } else {
        [self getWebImage];
    }
}

- (void)getWebImage {
    NSString *requestString = [NSString stringWithFormat:@"http://www.hackerschool.com%@", _currentStudent.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    UIImage *image = [UIImage imageNamed:@"logo"];
    _imageView.alpha = 0.3;
    [_imageView setImageWithURLRequest:request placeholderImage:image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            _currentStudent.image = imageData;
            [_objectContext save:nil];
        });
        [UIView animateWithDuration:0.2 animations:^{
            _imageView.alpha = 1.0;
            self.imageView.image = image;
        }];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}

@end
