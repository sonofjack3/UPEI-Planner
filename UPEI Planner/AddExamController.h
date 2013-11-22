//
//  AddExamController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Exam.h"
#import "StudentClass.h"

@interface AddExamController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property StudentClass *course;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;



@end
