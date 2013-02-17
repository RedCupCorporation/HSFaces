#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Batch : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * idName;
@property (nonatomic, retain) NSMutableSet *students;

@end
