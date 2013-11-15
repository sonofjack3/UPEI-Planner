//
//  EditStudentController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-13.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Student.h"

@interface EditStudentController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *idField;

@end
