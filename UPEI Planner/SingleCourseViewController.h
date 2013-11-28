//
//  SingleCourseViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays the information for a single course, and rows for assignments, projects and exams.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StudentClass.h"
#import "AddClassController.h"
#import "EditClassController.h"
#import "AssignmentsViewController.h"
#import "ProjectViewController.h"
#import "ExamViewController.h"

@interface SingleCourseViewController : UITableViewController

@property int rowNumber; //passed to this controller to indicate this controller's class index in the classes array
@property StudentClass *course; //passed to this controller to indicate this controller's course
@property (strong, nonatomic) NSString *classID; //passed simply to display the view's title

@end
