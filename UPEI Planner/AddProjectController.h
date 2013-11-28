//
//  AddProjectController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Used for adding a new project to the database.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Project.h"
#import "StudentClass.h"
#import <AddressBookUI/AddressBookUI.h>

@interface AddProjectController : UIViewController <UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *saveButton; //save button for saving user inputs to 
@property (strong, nonatomic) UIBarButtonItem *cancelButton; //cancel button for cancelling an add and popping this controller off the stack
@property StudentClass *course; //course to be associated with the new assignment

@property (weak, nonatomic) IBOutlet UITextField *nameField; //text field containing the assignment title
@property (weak, nonatomic) IBOutlet UITextField *dateField; //text field containing the assignment due date
@property (weak, nonatomic) IBOutlet UITextField *groupField; //text field containing the project team members
- (IBAction)selectMembers:(id)sender; //action called to select project team members from the Address Book

@end
