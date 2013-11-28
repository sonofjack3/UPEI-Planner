//
//  StudentClass.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-11.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents a Student Class, with attributes as described in the data model

#import "StudentClass.h"
#import "Project.h"

@implementation StudentClass

@dynamic classnumber; //course number (eg: 252)
@dynamic classprefix; //course prefix (eg: CS)
@dynamic name; //course name (eg: iPhone Programming)
@dynamic professor; //course professor's name
@dynamic assignment; //set of assignments for this course
@dynamic exam; //set of exams for this course
@dynamic project; //set of projects for this course
@dynamic student; //Student associated with this course

@end
