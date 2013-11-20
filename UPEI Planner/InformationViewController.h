//
//  InformationViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EditStudentController.h"
#import "CoursesViewController.h"
#import "Student.h"

@interface InformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSArray *studentArray;
- (IBAction)viewCourses:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *InfoView;


@end
