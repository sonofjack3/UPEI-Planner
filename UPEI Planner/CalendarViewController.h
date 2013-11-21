//
//  CalendarViewController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

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

@property (strong, nonatomic) NSMutableArray *exams;
@property (strong, nonatomic) NSMutableArray *assign;
@property (strong, nonatomic) NSMutableArray *projects;
@property StudentClass *course;
@property int rowNumber;
@property (strong, nonatomic) NSArray *classes;
@property (strong, nonatomic) NSString *classID;
@property (strong, nonatomic) NSMutableArray *examList;
@property (strong, nonatomic) NSMutableArray *assignList;
@property (strong, nonatomic) NSMutableArray *projectList;
@end
