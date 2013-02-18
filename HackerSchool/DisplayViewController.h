#import <UIKit/UIKit.h>
#import "Batch.h"
#import "Person.h"

@interface DisplayViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *guessTextbox;
@property (strong, nonatomic) Batch *batch;
@property (strong, nonatomic) Person *currentStudent;
@property (nonatomic) int lastGuess;

- (void)newStudentImage;

@end
