//
//  MoodleViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays a Web View that loads the UPEI Moodle site.

#import "MoodleViewController.h"

@interface MoodleViewController ()

@end

@implementation MoodleViewController

// Initialize using nib file
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self tabBarItem] setImage:[UIImage imageNamed:@"earth-usa"]]; //set tab bar icon
        [self setTitle:@"Moodle"];
    }
    return self;
}

// Called when a controller's view is loaded
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_webView setDelegate:self]; //set this controller as the web view's delegate
    
    /* initially back and forward buttons are disabled */
    _backButton.enabled = NO;
    _forwardButton.enabled = NO;
    /* My Courses button is always enabled */
    _myCoursesButton.enabled = YES;
    
    //Load Moodle in the web view
    _stringURL = @"http://moodle.upei.ca";
    NSURL *url = [NSURL URLWithString:_stringURL];
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the web view has finish loading
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    _backButton.enabled = [webView canGoBack]; //enable back button when web view can go back
    _forwardButton.enabled = [webView canGoForward]; //enable forward button when web view can go forward
}

// Send web view back one page
- (IBAction)backAction:(id)sender
{
    [_webView goBack];
}

// Send web view to the Moodle My Courses page
- (IBAction)myCoursesAction:(id)sender
{
    NSString *courseURL = @"http://moodle.upei.ca/my/";
    NSURL *url = [NSURL URLWithString:courseURL];
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObject];
}

// Send web view forward one page
- (IBAction)forwardAction:(id)sender
{
    [_webView goForward];
}
@end
