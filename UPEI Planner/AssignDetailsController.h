//
//  AssignDetailsController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"

@interface AssignDetailsController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dueField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property Assignment *assignment;
@end
