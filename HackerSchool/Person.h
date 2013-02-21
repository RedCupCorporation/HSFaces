#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Batch.h"


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) Batch * batch;


@end
