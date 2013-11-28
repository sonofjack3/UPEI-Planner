//
//  Project.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-25.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents a project, with attributes as described in the data model.

#import "Project.h"
#import "StudentClass.h"


@implementation Project

@dynamic completed; //0 if project is not completed, 1 otherwise
@dynamic due_date; //project due date
@dynamic mark; //project mark
@dynamic members; //object for holding project team members
@dynamic name; //project title
@dynamic classes; //class associated with this project

@end
