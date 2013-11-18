//
//  SingleCourseViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StudentClass.h"

@interface SingleCourseViewController : UITableViewController

@property (nonatomic) int rowNumber;
@property (strong, nonatomic) NSArray *classes;
@property (strong, nonatomic) NSString *classID;

@end
