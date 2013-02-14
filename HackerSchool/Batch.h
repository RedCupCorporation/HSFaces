//
//  Batch.h
//  HackerSchool
//
//  Created by Adam Fraser on 14/02/13.
//  Copyright (c) 2013 Adam Fraser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Batch : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * idName;

@end
