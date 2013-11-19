//
//  ProjectViewController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "AppDelegate.h"
#import "AddProjectController.h"
#import "StudentClass.h"
#import "ProjectDetailsController.h"
//#import "SingleCourseViewController.h"

@interface ProjectViewController : UITableViewController <UITableViewDataSource, UITabBarDelegate>

@property (strong, nonatomic) NSMutableArray *projects;
@property StudentClass *course;

@end
