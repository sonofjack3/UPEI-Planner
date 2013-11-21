//
//  ExamDetailsController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exam.h"
#import "AppDelegate.h"

@interface ExamDetailsController : UIViewController <UITextFieldDelegate>
@property Exam *exam;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *completeSelect;
@property (weak, nonatomic) IBOutlet UITextField *markField;
- (IBAction)completedChange:(id)sender;

@end
