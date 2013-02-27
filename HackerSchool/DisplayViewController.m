#import "DisplayViewController.h"
#import "AppDelegate.h"
#import "Person.h"
#import <AFNetworking.h>

NSString *const HIGH_SCORE_MESSAGE = @"Nice Work!";
NSString *const MEDIUM_SCORE_MESSAGE = @"You're getting there!";
NSString *const LOW_SCORE_MESSAGE = @"I think you need a little more practice.";
NSString *const VERY_LOW_SCORE_MESSAGE = @"Uh..oh I hope your new here.";

@interface DisplayViewController ()

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    self.objectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.students = [[self.batch.students allObjects] mutableCopy];
    self.score = 0;
    self.guesses = 0;
    self.guessButton.enabled = NO;
    self.guessTextbox.delegate = self;
    [self.guessTextbox addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventAllEditingEvents];
    [self.guessTextbox becomeFirstResponder];

    [self newStudentImage];
    self.title = @"Hacker School Faces";
}

- (void)setupViews {
    if ([[UIScreen mainScreen] bounds].size.height > 500) {
        self.submitFormView.frame = CGRectOffset(self.submitFormView.frame, 0, 87);
        self.imageView.frame = CGRectInset(self.imageView.frame, -20, -20);
        self.imageView.frame = CGRectMake(CGRectGetMinX(self.imageView.frame)-10, CGRectGetMinY(self.imageView.frame)+20, CGRectGetWidth(self.imageView.frame)+20, CGRectGetHeight(self.imageView.frame)+20);
    }
}

- (void)guessSequence {
    if ([self guessName]) {
        [self displayCorrect];
        self.score++;
        self.guesses++;
    } else {
        self.guesses++;
        [self displayError];
        self.guessButton.enabled = NO;
    }
    [self performSelector:@selector(nextGuess) withObject:nil afterDelay:1.0];
}

- (void)nextGuess {
    [self.warning removeFromSuperview];
    [self.correctImage removeFromSuperview];
    [self removeStudent];
    self.guessTextbox.text = @"";
    [self textChanged];
    if ([self.students count] == 0) {
        NSString *message;
        float percentage = (float)self.score / self.guesses;
        if (percentage > 0.95) {
            message = HIGH_SCORE_MESSAGE;
        } else if (percentage > 0.75) {
            message = MEDIUM_SCORE_MESSAGE;
        } else if (percentage > 0.30) {
            message = LOW_SCORE_MESSAGE;
        } else {
            message = VERY_LOW_SCORE_MESSAGE;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You scored %d out of %d", self.score, self.guesses] message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self newStudentImage];
}

- (void)removeStudent {
    [self.students removeObject:self.currentStudent];
}

- (BOOL)guessName {
    NSArray *parts = [self.currentStudent.name componentsSeparatedByString:@" "];
    if ([[self.guessTextbox.text lowercaseString] isEqualToString:[[parts objectAtIndex:0] lowercaseString]] || [[self.guessTextbox.text lowercaseString] isEqualToString:[self.currentStudent.name lowercaseString]] ) {
        return YES;
    } else {
        return NO;
    }
}

- (void)displayCorrect {
    self.correctImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 200, 200)];
    self.correctImage.image = [UIImage imageNamed:@"correct@2x.png"];
    [self.view addSubview:self.correctImage];
    [UIView animateWithDuration:0.15 animations:^{
        self.correctImage.frame = CGRectInset(self.imageView.frame, 10, 10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.correctImage.frame = self.imageView.frame;
        }];
    }];
}

- (void)displayError {
    NSString *name = [[self.currentStudent.name componentsSeparatedByString:@" "] objectAtIndex:0];

    self.warning = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.imageView.frame), CGRectGetMaxY(self.imageView.frame), 200, 50)];
    self.warning.numberOfLines = 0;
    self.warning.textAlignment = NSTextAlignmentCenter;
    self.warning.text = [NSString stringWithFormat:@"Uhoh.. that was %@", name];
    self.warning.backgroundColor = [UIColor clearColor];
    self.warning.font = [UIFont systemFontOfSize:50];
    self.warning.textColor = [UIColor redColor];
    [self.view addSubview:self.warning];

    [UIView animateWithDuration:0.1 animations:^{
        self.imageView.alpha = 0.5;
        self.warning.frame = CGRectMake(CGRectGetMinX(self.imageView.frame)-50, CGRectGetMaxY(self.imageView.frame)-100, 200, 100);
        self.warning.font = [UIFont boldSystemFontOfSize:25];
        self.warning.transform = CGAffineTransformMakeRotation(-0.6);
    }];
}

- (IBAction)submit:(id)sender {
    [self guessSequence];
}

- (void)newStudentImage {
    NSUInteger num;
    do {
        num = arc4random_uniform([self.students count]+1);
        if (!(num == 0)) {
            num -=1;
        }
    } while (num == self.lastGuess && [self.students count] > 1);

    self.currentStudent = [self.students objectAtIndex:num];
    self.lastGuess = num;

    if (self.currentStudent.image) {
        UIImage *image = [UIImage imageWithData:self.currentStudent.image];
        self.imageView.image = image;
    } else {
        [self getWebImage];
    }
}

- (void)getWebImage {
    NSString *requestString = [NSString stringWithFormat:@"http://www.hackerschool.com%@", self.currentStudent.imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    UIImage *image = [UIImage imageNamed:@"logo"];
    self.imageView.alpha = 0.3;
    [self.imageView setImageWithURLRequest:request placeholderImage:image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            self.currentStudent.image = imageData;
            [self.objectContext save:nil];
        });
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.alpha = 1.0;
            self.imageView.image = image;
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        self.imageView.alpha = 0.3;
    }];
}

- (void)handleTap {
    if ([self.guessTextbox.text length] == 0) {
        return;
    }
    [self guessSequence];
}

- (void)textChanged {
    if ([self.guessTextbox.text length] > 0) {
        self.guessButton.enabled = YES;
    } else {
        self.guessButton.enabled = NO;
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
