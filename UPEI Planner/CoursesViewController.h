//
//  CoursesViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-16.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentClass.h"
#import "AppDelegate.h"
#import "AddClassController.h"
#import "SingleCourseViewController.h"

@interface CoursesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *classes;

@end
