//
//  Exam.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-25.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents an exam, with attributes as described in the data model.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentClass;

@interface Exam : NSManagedObject

@property (nonatomic, retain) NSNumber * completed; //0 if exam is not completed, 1 otherwise
@property (nonatomic, retain) NSString * due_date; //exam due date
@property (nonatomic, retain) NSNumber * mark; //exam mark
@property (nonatomic, retain) NSString * name; //exam title
@property (nonatomic, retain) StudentClass *classes; //class associated with this exam

@end
