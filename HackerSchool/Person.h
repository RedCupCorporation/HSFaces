#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Batch.h"


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) Batch * batch;

@end
