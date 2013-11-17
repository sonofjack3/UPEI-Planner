//
//  AddClassController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-17.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StudentClass.h"

@interface AddClassController : UIViewController

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet UITextField *prefixField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *profField;

@end
