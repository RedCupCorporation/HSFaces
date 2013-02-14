#import "ViewController.h"
#import "Parser.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webView setBackgroundColor:[UIColor redColor]];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.hackerschool.com/private"] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:60];
    [_webView loadRequest:request];
    Parser *paser = [[Parser alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _objectContext = [appDelegate managedObjectContext];
}



#pragma - mark FetchResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tableView beginUpdates];
    NSLog(@"beginning updates");
}

- (NSFetchedResultsController *)fetchedResultsController {

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Person" inManagedObjectContext:_objectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

    [fetchRequest setFetchBatchSize:20];

    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_objectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = person.name;

    return cell;
}



#pragma - mark Web View Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.frame = CGRectMake(360/2, 480/2, 40, 40);
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    [_spinner stopAnimating];
}

@end
