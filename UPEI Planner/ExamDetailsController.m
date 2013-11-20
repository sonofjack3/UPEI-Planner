//
//  ExamDetailsController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "ExamDetailsController.h"

@interface ExamDetailsController ()

@end

@implementation ExamDetailsController
@synthesize nameField;
@synthesize dateField;
@synthesize weightField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self dateField]setText:[_exam due_date]];
    [[self weightField]setText:[[_exam weight]stringValue]];
    [[self nameField]setText:[_exam name]];
    [_completeSelect setSelectedSegmentIndex:[[_exam completed]integerValue]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
