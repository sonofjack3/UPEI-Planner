//
//  CoursesViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-16.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays a table view of the Student's courses

#import <UIKit/UIKit.h>
#import "StudentClass.h"
#import "AppDelegate.h"
#import "AddClassController.h"
#import "SingleCourseViewController.h"
#import "Student.h"
#define MAX_COURSES 5

@interface CoursesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *classes; //classes to be displayed
@property (strong, nonatomic) NSIndexPath *indexPathToBeDeleted; //used for deleting classes
@property (strong, nonatomic) UIAlertView *deleteAlert; //alert view to confirm a course deletion
@property (strong, nonatomic) UIAlertView *maxAlert; //alert view indicating maximum number of courses has been reached

@end
