//
//  AssignDetailsController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "AssignDetailsController.h"

@interface AssignDetailsController ()

@end

@implementation AssignDetailsController
@synthesize nameField;
@synthesize dueField;
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
    [[self dueField]setText:[_assignment due_date]];
    [[self weightField]setText:[[_assignment weight]stringValue]];
    [[self nameField]setText:[_assignment name]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
