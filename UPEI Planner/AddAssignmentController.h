//
//  AddAssignmentController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Assignment.h"
#import "StudentClass.h"

@interface AddAssignmentController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property StudentClass *course;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *completedSelector;


@end
