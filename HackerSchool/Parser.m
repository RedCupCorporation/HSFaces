#import "Parser.h"
#import "Person.h"
#import "Batch.h"


@implementation Parser

- (Parser *)init {
    self = [super init];
    return self;
}

- (void)parseData:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *objectContext = [appDelegate managedObjectContext];

    NSArray *batchIds = [doc searchWithXPathQuery:@"//ul[@id='batches']/li/ul"];
    NSArray *batchNames = [doc searchWithXPathQuery:@"//ul[@id='batches']/li/h2"];

    for (int i = 0; i < [batchNames count]; i++) {
        if ([self existingItems:[batchIds objectAtIndex:i]]) {
            continue;
        }

        Batch *batch = [NSEntityDescription insertNewObjectForEntityForName:@"Batch" inManagedObjectContext:objectContext];
        batch.name = [[[batchNames objectAtIndex:i] firstChild] content];
        batch.idName = [(NSDictionary *)[[batchIds objectAtIndex:i] attributes] objectForKey:@"id"];
        NSError *error = nil;
        [objectContext save:&error];
        
        NSArray *peopleFromBatch = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li[@class='person']/div[@class='name']/a", batch.idName]];
        NSArray *imagesFromBatch = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li[@class='person']/a/img", batch.idName]];
        
        for (int i = 0; i < [peopleFromBatch count]; i++) {
            NSString *image = [(NSDictionary *)[[imagesFromBatch objectAtIndex:i] attributes] objectForKey:@"src"];
            NSString *name = [[[peopleFromBatch objectAtIndex:i] firstChild] content];
            Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:objectContext];
            [newPerson setName:name];
            [newPerson setImage:image];
            [newPerson setBatch:batch];
            NSError *error = nil;
            [objectContext save:&error];
        }
    }
}

- (BOOL)existingItems:(TFHppleElement *)batchElement {
    NSString *idName = [(NSDictionary *)[batchElement attributes] objectForKey:@"id"];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *objectContext = [appDelegate managedObjectContext];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Batch"];
    request.predicate = [NSPredicate predicateWithFormat:@"idName == %@", idName];
    NSUInteger count = [objectContext countForFetchRequest:request error:nil];
    if (count > 0) {
        return YES;
    }
    return NO;
}

@end
