//
//  Assignment.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-25.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents an assignment, with attributes as described in the data model.

#import "Assignment.h"
#import "StudentClass.h"

@implementation Assignment

@dynamic completed; //0 if assignment is not completed, 1 otherwise
@dynamic due_date; //assignment due date
@dynamic mark; //assignment mark
@dynamic name; //assignment title
@dynamic classes; //class associated with this assignment

@end
