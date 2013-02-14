//
//  Person.h
//  HackerSchool
//
//  Created by Adam Fraser on 13/02/13.
//  Copyright (c) 2013 Adam Fraser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * batch;

@end
