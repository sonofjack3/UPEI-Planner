//
//  AssignDetailsController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays attributes of a specific assignment.

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import "AppDelegate.h"

@interface AssignDetailsController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField; //text field containing the assignment title
@property (weak, nonatomic) IBOutlet UITextField *dueField; //text field containing the assignment due date
@property (weak, nonatomic) IBOutlet UISegmentedControl *completeSelect; //segmented control for setting the assignment's completion status
@property (weak, nonatomic) IBOutlet UITextField *markField; //text field containing the assignment mark
- (IBAction)completedChanged:(id)sender; //action called when segmented control is changed (completion status changed)
@property Assignment *assignment; //assignment associated with this controller
@end
