//
//  MoodleViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays a Web View that loads the UPEI Moodle site.

#import <UIKit/UIKit.h>

@interface MoodleViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView; //web view to display moodle page
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton; //back button for accessing web view history
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myCoursesButton; //sends web view to "moodle.upei.ca/my" (My Courses)
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton; //forward button for accessing web view history
@property (strong, nonatomic) NSString *stringURL; //holds the Moodle URL
- (IBAction)backAction:(id)sender; //sends web view back one page
- (IBAction)myCoursesAction:(id)sender; //sends web view to "moodle.upei.ca/my"
- (IBAction)forwardAction:(id)sender; //sends web view forward one page

@end