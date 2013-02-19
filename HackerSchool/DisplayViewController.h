#import <UIKit/UIKit.h>
#import "Batch.h"
#import "Person.h"

@interface DisplayViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic) int score;
@property (nonatomic) int guesses;
@property (strong, nonatomic) NSMutableArray *students;

@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) UILabel *warning;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *guessTextbox;
@property (strong, nonatomic) IBOutlet UIButton *guessButton;
@property (strong, nonatomic) IBOutlet UIView *submitFormView;

@property (strong, nonatomic) Batch *batch;
@property (strong, nonatomic) Person *currentStudent;
@property (nonatomic) int lastGuess;
- (IBAction)submit:(id)sender;

- (void)newStudentImage;

@end
