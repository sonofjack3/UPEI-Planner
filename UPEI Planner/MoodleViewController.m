//
//  MoodleViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "MoodleViewController.h"

@interface MoodleViewController ()

@end

@implementation MoodleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self tabBarItem] setTitle:@"Moodle"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_webView setDelegate:self]; //set this controller as the web view's delegate
    
    /* initially back and forward buttons are disabled */
    _backButton.enabled = NO;
    _forwardButton.enabled = NO;
    /* My Courses button is always enabled */
    _myCoursesButton.enabled = YES;
    
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

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    _backButton.enabled = [webView canGoBack]; //enable back button when web view can go back
    _forwardButton.enabled = [webView canGoForward]; //enable forward button when web view can go forward
}

- (IBAction)backAction:(id)sender
{
    [_webView goBack];
}
- (IBAction)myCoursesAction:(id)sender
{
    NSString *courseURL = @"http://moodle.upei.ca/my/";
    NSURL *url = [NSURL URLWithString:courseURL];
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObject];
}

- (IBAction)forwardAction:(id)sender
{
    [_webView goForward];
}
@end
