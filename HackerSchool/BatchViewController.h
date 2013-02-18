#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BatchViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *objectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (IBAction)reloadtable:(id)sender;

@end
