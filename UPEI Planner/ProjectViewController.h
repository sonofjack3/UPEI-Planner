//
//  ProjectViewController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays all projects for a course in a table.

#import <UIKit/UIKit.h>
#import "Project.h"
#import "AppDelegate.h"
#import "AddProjectController.h"
#import "StudentClass.h"
#import "ProjectDetailsController.h"

@interface ProjectViewController : UITableViewController <UITableViewDataSource, UITabBarDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *projects; //projects to be listed in the table
@property StudentClass *course; //course associated with this controller's projects
@property (strong, nonatomic) NSIndexPath *indexPathToBeDeleted; //used to look up the project to be deleted within the database

@end
