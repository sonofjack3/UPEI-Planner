//
//  MoodleViewController.h
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodleViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView; //web view to display moodle page
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton; //back button for accessing web view history
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myCoursesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (strong, nonatomic) NSString *stringURL;
- (IBAction)backAction:(id)sender; //sends web view back one page
- (IBAction)myCoursesAction:(id)sender;
- (IBAction)forwardAction:(id)sender;

@end