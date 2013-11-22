//
//  ProjectDetailsController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "ProjectDetailsController.h"

@interface ProjectDetailsController ()

@end

@implementation ProjectDetailsController

@synthesize nameField;
@synthesize dateField;
@synthesize weightField;
@synthesize markField;
@synthesize completeSelect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[_project name]];
    [[self dateField]setText:[_project due_date]];
    [[self weightField]setText:[[_project weight]stringValue]];
    [[self nameField]setText:[_project name]];
    [[self membersField]setText:[_project members]];
    [[self markField]setText:[[_project mark] stringValue]];
    [completeSelect setSelectedSegmentIndex:[[_project completed]integerValue]];
    [dateField setUserInteractionEnabled:YES];
    [weightField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [completeSelect setUserInteractionEnabled:YES];
    if ([[_project completed] boolValue] == NO) //if assignment is not completed
    {
        [markField setText:@""];
        [markField setUserInteractionEnabled:NO]; //mark field editable only when assignment has been completed
        [markField setAlpha:0.3];
    }
    else //assignment is completed
    {
        [markField setUserInteractionEnabled:YES];
        [markField setAlpha:1];
    }
}

- (void) saveChanges
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_project setDue_date:[dateField text]];
    [_project setWeight:[formatter numberFromString:[weightField text]]];
    [_project setName:[nameField text]];
    [_project setMark:[formatter numberFromString:[markField text]]];
    [self viewDidLoad];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:dateField]) //bring up date picker when due field is tapped
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
        [self.dateField setInputView:datePicker];
        return YES;
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (AppDelegate *) appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//User edits saved after fields are edited; called when first responder status is resigned
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self saveChanges];
}

-(void)updateTextField:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yy HH:mm"];
    UIDatePicker *picker = (UIDatePicker*)self.dateField.inputView;
    self.dateField.text = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:picker.date]];
    [self saveChanges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Called when segmented control is changed
- (IBAction)completedChanged:(id)sender
{
    [_project setCompleted:[NSNumber numberWithInteger:[completeSelect selectedSegmentIndex]]];
    [self viewDidLoad];
}
@end
