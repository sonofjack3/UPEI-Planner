//
//  AssignmentsViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays all assignments for a course in a table.

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import "AppDelegate.h"
#import "AddAssignmentController.h"
#import "StudentClass.h"
#import "AssignDetailsController.h"

@interface AssignmentsViewController : UITableViewController <UITableViewDataSource, UITabBarDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *assignments; //assignments to be listed in the table
@property StudentClass *course; //course associated with this controller's assignments
@property (strong, nonatomic) NSIndexPath *indexPathToBeDeleted; //used to look up the assignment to be deleted within the database

@end
