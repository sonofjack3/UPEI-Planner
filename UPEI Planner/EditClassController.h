//
//  EditClassController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Used for editing class information.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StudentClass.h"

@interface EditClassController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UIBarButtonItem *saveButton; //save button for saving user inputs to
@property (strong, nonatomic) UIBarButtonItem *cancelButton; //cancel button for cancelling an add and popping this controller off the stack
@property int rowNumber; //passed by SingleCourseViewController to indicate this controller's course's index within the database

@property (weak, nonatomic) IBOutlet UITextField *prefixField; //text field containing class prefix
@property (weak, nonatomic) IBOutlet UITextField *numberField; //text field containing class number
@property (weak, nonatomic) IBOutlet UITextField *nameField; //text field containing class name
@property (weak, nonatomic) IBOutlet UITextField *profField; //text field containing course's professor

@end
