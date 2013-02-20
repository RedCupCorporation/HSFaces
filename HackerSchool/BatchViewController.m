#import "BatchViewController.h"
#import "Parser.h"
#import "Person.h"
#import "Batch.h"
#import "AppDelegate.h"

@interface BatchViewController ()

@end

@implementation BatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _objectContext = [appDelegate managedObjectContext];
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
    _tableView.frame = CGRectMake(0, 0, width, height);
    _tableView.contentInset = UIEdgeInsetsMake(90, 0, 20, 0);
    _tableView.backgroundView = _tableBackgroundImageView;
}

- (void)reloadtable:(id)sender {
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Batch *batch = [_fetchedResultsController objectAtIndexPath:[_tableView indexPathForSelectedRow]];
    [segue.destinationViewController setBatch:batch];
}

#pragma - mark FetchResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tableView beginUpdates];
}

- (NSFetchedResultsController *)fetchedResultsController {

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Batch" inManagedObjectContext:_objectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"idName" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

    [fetchRequest setFetchBatchSize:20];

    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_objectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
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
