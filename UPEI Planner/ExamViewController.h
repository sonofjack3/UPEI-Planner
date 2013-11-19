//
//  ExamViewController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exam.h"
#import "AppDelegate.h"
#import "AddExamController.h"
#import "StudentClass.h"
//#import "SingleCourseViewController.h"

@interface ExamViewController : UITableViewController <UITableViewDataSource, UITabBarDelegate>

@property (strong, nonatomic) NSMutableArray *exams;
@property StudentClass *course;

@end
