//
//  ExamViewController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays all exams for a course in a table.

#import <UIKit/UIKit.h>
#import "Exam.h"
#import "AppDelegate.h"
#import "AddExamController.h"
#import "StudentClass.h"
#import "ExamDetailsController.h"

@interface ExamViewController : UITableViewController <UITableViewDataSource, UITabBarDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *exams; //exams to be listed in the table
@property StudentClass *course; //course associated with this controller's exams
@property (strong, nonatomic) NSIndexPath *indexPathToBeDeleted; //used to look up the exam to be deleted within the database

@end
