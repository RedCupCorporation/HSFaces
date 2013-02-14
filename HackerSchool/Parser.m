#import "Parser.h"
#import "Person.h"


@implementation Parser

- (Parser *)init {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.hackerschool.com/private"]];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *objectContext = [appDelegate managedObjectContext];

    NSArray *batchIds = [doc searchWithXPathQuery:@"//ul[@id='batches']/li/ul"];
    for (TFHppleElement *batchID in batchIds) {
        NSString *idName = [(NSDictionary *)[batchID attributes] objectForKey:@"id"];
        NSArray *peopleFromBatch = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li[@class='person']/div[@class='name']/a", idName]];
        NSArray *imagesFromBatch = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li[@class='person']/a/img", idName]];

        NSLog(@"%@", idName);
        for (int i = 0; i < [peopleFromBatch count]; i++) {
            NSString *image = [(NSDictionary *)[[imagesFromBatch objectAtIndex:i] attributes] objectForKey:@"src"];
            NSString *name = [[[peopleFromBatch objectAtIndex:i] firstChild] content];
            Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:objectContext];
            [newPerson setName:name];
            [newPerson setImage:image];
            [newPerson setBatch:idName];
            NSError *error = nil;
            [objectContext save:&error];
        }
    }
    return nil;
}

@end
