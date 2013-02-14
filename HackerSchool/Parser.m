#import "Parser.h"
#import "Person.h"


@implementation Parser

- (Parser *)init {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.hackerschool.com/private"]];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];

//    NSArray *batches = [doc searchWithXPathQuery:@"//ul[@id='batches']/li/h2"];
//    for (TFHppleElement *batch in batches) {
//        NSLog(@"%@", [[batch firstChild] content]);
//    }

//    NSArray *people = [doc searchWithXPathQuery:@"//ul[@id='batches']/li/ul/li[@class='person']/div[@class='name']/a"];
//    for (TFHppleElement *person in people) {
//        NSLog(@"%@", [[person firstChild] content]);
//    }

//    NSArray *images = [doc searchWithXPathQuery:@"//ul[@id='batches']/li/ul/li[@class='person']/a/img"];
//    for (TFHppleElement *image in images) {
//        NSLog(@"%@", [(NSDictionary *)[image attributes] objectForKey:@"src"]);
//    }

    NSArray *batchIds = [doc searchWithXPathQuery:@"//ul[@id='batches']/li/ul"];
    for (TFHppleElement *batchID in batchIds) {
        NSString *idName = [(NSDictionary *)[batchID attributes] objectForKey:@"id"];
        NSArray *peopleFromBatch = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li[@class='person']/div[@class='name']/a", idName]];
        NSArray *imagesFromBatch = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//ul[@id='%@']/li[@class='person']/a/img", idName]];

        NSLog(@"%@", idName);
        for (int i = 0; i < [peopleFromBatch count]; i++) {
            NSLog(@"%@", [(NSDictionary *)[[imagesFromBatch objectAtIndex:i] attributes] objectForKey:@"src"]);
            NSLog(@"%@", [[[peopleFromBatch objectAtIndex:i] firstChild] content]);
        }

//        NSLog(@"%@", idName);
//        for (TFHppleElement *name in peopleFromBatch) {
//            NSLog(@"%@", name);
//            NSLog(@"%@", [[name firstChild] content]);
//        }
    }

//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//
//    NSManagedObjectContext *objectContext = [appDelegate managedObjectContext];
//    Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:objectContext];
//    [newPerson setName:@""];
//    [newPerson setBatch:@""];
//    [newPerson setImage:@""];
//
    return nil;
}

@end
