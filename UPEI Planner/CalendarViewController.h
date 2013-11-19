//
//  CalendarViewController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exam.h"
#import "AppDelegate.h"
#import "StudentClass.h"

@interface CalendarViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *exams;
@property StudentClass *course;
@property int rowNumber;
@property (strong, nonatomic) NSArray *classes;
@property (strong, nonatomic) NSString *classID;
@property (strong, nonatomic) NSMutableArray *examList;
@end
