#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BatchViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *objectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UIImageView *tableBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)resetData:(id)sender;

@end
