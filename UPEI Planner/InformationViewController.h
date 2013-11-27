//
//  InformationViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Planner View displays the Student's information (name, ID, picture) and a View Courses button

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EditStudentController.h"
#import "CoursesViewController.h"
#import "Student.h"

@interface InformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *idLabel; //label for Student's ID
@property (weak, nonatomic) IBOutlet UILabel *courseLabel; //label for the number of courses associated with the Student
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //label for Student's name
@property (weak, nonatomic) IBOutlet UIImageView *imageView; //contains the Student's selected profile picture
@property (strong, nonatomic) NSArray *studentArray; //array containing the one Student in the database
- (IBAction)viewCourses:(id)sender; //button for accessing the Student's courses
@property (strong, nonatomic) IBOutlet UIView *InfoView; //reference to the UIView


@end
