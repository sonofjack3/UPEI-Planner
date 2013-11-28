//
//  Assignment.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-25.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents an assignment, with attributes as described in the data model.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentClass;

@interface Assignment : NSManagedObject

@property (nonatomic, retain) NSNumber * completed; //0 if assignment is not completed, 1 otherwise
@property (nonatomic, retain) NSString * due_date; //assignment due date
@property (nonatomic, retain) NSNumber * mark; //assignment mark
@property (nonatomic, retain) NSString * name; //assignment title
@property (nonatomic, retain) StudentClass *classes; //class associated with this assignment

@end
