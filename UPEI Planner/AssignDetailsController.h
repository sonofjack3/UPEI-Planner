//
//  AssignDetailsController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import "AppDelegate.h"

@interface AssignDetailsController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dueField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *completeSelect;
@property (weak, nonatomic) IBOutlet UITextField *markField;
- (IBAction)completedChanged:(id)sender;
@property Assignment *assignment;
@end
