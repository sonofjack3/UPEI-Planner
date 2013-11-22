//
//  Project.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-11.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentClass;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * due_date;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * mark;
@property (nonatomic, retain) id members;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) StudentClass *classes;

@end
