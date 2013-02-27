#import "BatchViewController.h"
#import "Parser.h"
#import "Person.h"
#import "Batch.h"
#import "AppDelegate.h"

@interface BatchViewController ()

@end

@implementation BatchViewController
const int kTableViewContentInset = 90;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.objectContext = [appDelegate managedObjectContext];
    [self setupView];
    [self.navigationItem setHidesBackButton:YES];
    self.title = @"Batches";
    [self reloadtable:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)setupView {
    int height = [[UIScreen mainScreen] bounds].size.height;
    int width = [[UIScreen mainScreen] bounds].size.width;
    self.tableView.frame = CGRectMake(0, 0, width, height);
    self.tableView.contentInset = UIEdgeInsetsMake(kTableViewContentInset, 0, 0, 0);
    self.tableView.backgroundView = self.tableBackgroundImageView;
}

- (void)reloadtable:(id)sender {
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Batch *batch = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    [segue.destinationViewController setBatch:batch];
}

#pragma - mark FetchResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (NSFetchedResultsController *)fetchedResultsController {

    if (self.fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Batch" inManagedObjectContext:self.objectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"idName" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

    [fetchRequest setFetchBatchSize:20];

    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.objectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    return self.fetchedResultsController;
}

#pragma - mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Hide resetButton when tableview is scrolled above it.
    int alp = self.tableView.contentOffset.y - -kTableViewContentInset;
    float alpha = 1-(alp / 25.0);
    self.resetButton.alpha = alpha;
    self.tableBackgroundImageView.alpha = alpha;
}

#pragma - mark TableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"BatchCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    Batch *batch = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = batch.name;
    cell.contentView.backgroundColor = [UIColor whiteColor];

    return cell;
}

- (IBAction)resetData:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset app data" message:@"This will reset all data stored in the app. You will have to resync." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSManagedObjectContext *objectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSFetchRequest *fetchBatches = [[NSFetchRequest alloc] initWithEntityName:@"Batch"];
        [fetchBatches setIncludesPropertyValues:NO];

        NSFetchRequest *fetchStudents = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
        [fetchStudents setIncludesPropertyValues:NO];

        NSArray *batches = [objectContext executeFetchRequest:fetchBatches error:nil];
        for (Batch *batch in batches) {
            [objectContext deleteObject:batch];
        }

        NSArray *people = [objectContext executeFetchRequest:fetchStudents error:nil];
        for (Person *person in people) {
            [objectContext deleteObject:person];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
