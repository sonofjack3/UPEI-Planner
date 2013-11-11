//
//  InformationViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Student.h"

@interface InformationViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) NSArray *studentArray;
@end
