//
//  CalendarViewController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays an Agenda table which shows all incompleted items.

#import <UIKit/UIKit.h>
#import "Exam.h"
#import "Assignment.h"
#import "Project.h"
#import "AppDelegate.h"
#import "StudentClass.h"
#import "AssignDetailsController.h"
#import "ExamDetailsController.h"
#import "ProjectDetailsController.h"

@interface CalendarViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *exams; //complete set of exams for the Student
@property (strong, nonatomic) NSMutableArray *assign; //complete set of assignments for the Student
@property (strong, nonatomic) NSMutableArray *projects; //complete set of projects for the Student
@property StudentClass *course; //variable to hold class (used when gathering assignments, exams, projects)
@property (strong, nonatomic) NSArray *classes; //array of all classes for the Student
@property (strong, nonatomic) NSMutableArray *examList; //array to hold incomplete exams
@property (strong, nonatomic) NSMutableArray *assignList; //array to hold incomplete assignments
@property (strong, nonatomic) NSMutableArray *projectList; //array to hold complete projects
@end
