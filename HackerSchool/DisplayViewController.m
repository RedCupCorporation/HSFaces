#import "DisplayViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import <AFNetworking.h>

@interface DisplayViewController ()

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _students = [[_batch.students allObjects] mutableCopy];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tap];
    _score = 0;
    _guesses = 0;
    _guessTextbox.delegate = self;
    [self newStudentImage];
}

- (IBAction)guessName {
    NSArray *parts = [_currentStudent.name componentsSeparatedByString:@" "];
    if ([[_guessTextbox.text lowercaseString] isEqualToString:[[parts objectAtIndex:0] lowercaseString]]) {
        [self correctGuess];
    } else {
        [self incorrectGuess:[parts objectAtIndex:0]];
    }
    [self updateScore];
    [_students removeObject:_currentStudent];
    NSLog(@"removeing %@", _currentStudent.name);
    NSLog(@"%d students left", [_students count]);
    if ([_students count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You scored %d out of %d", _score, _guesses] message:@"Nice Work!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self newStudentImage];
}

- (void)correctGuess {
    _score++;
    _guesses++;
}

- (void)incorrectGuess:(NSString *)name {
    _guesses++;
    UILabel *incorrect = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 200, 50)];
    incorrect.text = [NSString stringWithFormat:@"Uhoh.. that was %@", name];
    incorrect.backgroundColor = [UIColor clearColor];
    incorrect.font = [UIFont systemFontOfSize:50];
    incorrect.textColor = [UIColor redColor];
    [self.view addSubview:incorrect];

    [UIView animateWithDuration:0.1 animations:^{
        incorrect.frame = CGRectMake(CGRectGetMinX(_imageView.frame)-50, CGRectGetMaxY(_imageView.frame)-100, 300, 50);
        incorrect.font = [UIFont boldSystemFontOfSize:25];
        incorrect.transform = CGAffineTransformMakeRotation(-0.6);
    } completion:^(BOOL finished) {
        sleep(1);
        [incorrect removeFromSuperview];
    }];
}

- (void)updateScore {
    _scoreLabel.text = [NSString stringWithFormat:@"%d / %d", _score, _guesses];
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
    NSLog(@"current student is %@", _currentStudent.name);
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
    _guessTextbox.text = @"";
}

- (void)handleTap {
    if ([_guessTextbox.text length] == 0) {
        return;
    }
    [self guessName];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.frame = CGRectOffset(_imageView.frame, 0, 20);
        _imageView.frame = CGRectInset(_imageView.frame, -10, -10);
        _guessTextbox.frame = CGRectOffset(_guessTextbox.frame, 0, 20);
        _scoreLabel.frame = CGRectOffset(_scoreLabel.frame, 0, 20);
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.frame = CGRectOffset(_imageView.frame, 0, -20);
        _imageView.frame = CGRectInset(_imageView.frame, 10, 10);
        _guessTextbox.frame = CGRectOffset(_guessTextbox.frame, 0, -20);
        _scoreLabel.frame = CGRectOffset(_scoreLabel.frame, 0, -20);
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController  popViewControllerAnimated:YES];
}

@end
