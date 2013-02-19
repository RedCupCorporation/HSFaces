#import <UIKit/UIKit.h>
#import "Batch.h"
#import "Person.h"

@interface DisplayViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic) int score;
@property (nonatomic) int guesses;
@property (strong, nonatomic) NSMutableArray *students;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *guessTextbox;
@property (strong, nonatomic) Batch *batch;
@property (strong, nonatomic) Person *currentStudent;
@property (nonatomic) int lastGuess;

- (IBAction)guessName:(id)sender;
- (void)newStudentImage;

@end
