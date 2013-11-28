//
//  AddAssignmentController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Used for adding a new assignment to the database.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Assignment.h"
#import "StudentClass.h"

@interface AddAssignmentController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UIBarButtonItem *saveButton; //save button for saving user inputs to 
@property (strong, nonatomic) UIBarButtonItem *cancelButton; //cancel button for cancelling an add and popping this controller off the stack
@property StudentClass *course; //course to be associated with the new assignment

@property (weak, nonatomic) IBOutlet UITextField *nameField; //text field containing the assignment title
@property (weak, nonatomic) IBOutlet UITextField *dateField; //text field containing the assignment due date

@end
