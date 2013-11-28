//
//  ExamDetailsController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays attributes of a specific exam.

#import <UIKit/UIKit.h>
#import "Exam.h"
#import "AppDelegate.h"

@interface ExamDetailsController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField; //text field containing the exam title
@property (weak, nonatomic) IBOutlet UITextField *dateField; //text field containing the exam due date
@property (weak, nonatomic) IBOutlet UISegmentedControl *completeSelect; //segmented control for setting the assignment's completion status
@property (weak, nonatomic) IBOutlet UITextField *markField; //text field containing the assignment mark
- (IBAction)completedChange:(id)sender; //action called when segmented control is changed (completion status changed)
@property Exam *exam; //exam associated with this controller

@end
