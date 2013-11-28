//
//  Exam.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-25.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents an exam, with attributes as described in the data model.

#import "Exam.h"
#import "StudentClass.h"


@implementation Exam

@dynamic completed; //0 if exam is not completed, 1 otherwise
@dynamic due_date; //exam due date
@dynamic mark; //exam mark
@dynamic name; //exam title
@dynamic classes; //class associated with this exam

@end
