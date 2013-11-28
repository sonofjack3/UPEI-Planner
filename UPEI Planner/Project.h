//
//  Project.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-25.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents a project, with attributes as described in the data model.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentClass;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * completed; //0 if project is not completed, 1 otherwise
@property (nonatomic, retain) NSString * due_date; //project due date
@property (nonatomic, retain) NSNumber * mark; //project mark
@property (nonatomic, retain) id members; //object for holding project team members
@property (nonatomic, retain) NSString * name; //project title
@property (nonatomic, retain) StudentClass *classes; //class associated with this project

@end
