//
//  AddExamController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Used for adding a new assignment to the database.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Exam.h"
#import "StudentClass.h"

@interface AddExamController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UIBarButtonItem *saveButton; //save button for saving user inputs to 
@property (strong, nonatomic) UIBarButtonItem *cancelButton; //cancel button for cancelling an add and popping this controller off the stack
@property StudentClass *course; //course to be associated with the new exam

@property (weak, nonatomic) IBOutlet UITextField *nameField; //text field containing the exam title
@property (weak, nonatomic) IBOutlet UITextField *dateField; //text field containing the exam due date

@end
