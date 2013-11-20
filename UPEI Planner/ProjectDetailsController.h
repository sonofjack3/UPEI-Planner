//
//  ProjectDetailsController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
#import "Project.h"
#import <UIKit/UIKit.h>

@interface ProjectDetailsController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UITextField *membersField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *completeSelect;
@property Project *project;
@end
