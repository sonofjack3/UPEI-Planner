//
//  ProjectDetailsController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays attributes of a specific project.

#import "Project.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ProjectDetailsController : UIViewController <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField; //text field containing the project title
@property (weak, nonatomic) IBOutlet UITextField *dateField; //text field containing the project due date
@property (weak, nonatomic) IBOutlet UITextField *membersField; //text field containg the team project members
@property (weak, nonatomic) IBOutlet UISegmentedControl *completeSelect;; //segmented control for setting the project's completion status
@property (weak, nonatomic) IBOutlet UITextField *markField; //text field containing the project mark
- (IBAction)completedChanged:(id)sender; //action called when segmented control is changed (completion status changed)
- (IBAction)selectMembers:(id)sender; //project associated with this controller

@property Project *project;
@end
