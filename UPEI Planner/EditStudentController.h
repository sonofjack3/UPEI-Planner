//
//  EditStudentController.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-13.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays a view for editing Student information

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Student.h"
#import "InformationViewController.h"

@interface EditStudentController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField; //contains Student name
@property (weak, nonatomic) IBOutlet UITextField *idField; //contains Student ID
@property (strong, nonatomic) UIBarButtonItem *saveButton; //button for saving user inputs to the database
@property (strong, nonatomic) UIBarButtonItem *cancelButton; //button for cancelling and exiting the edit view
- (IBAction)choosePhoto:(id)sender; //used to choose a profile picture from the iPhone library
@property (weak, nonatomic) IBOutlet UIImageView *imageView; //contains the user's selected image

@end
