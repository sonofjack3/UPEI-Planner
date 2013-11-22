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
    [self setTitle:[_assignment name]];
    [[self dueField]setText:[_assignment due_date]];
    [[self nameField]setText:[_assignment name]];
    [[self markField] setText:[[_assignment mark] stringValue]];
    [completeSelect setSelectedSegmentIndex:[[_assignment completed]integerValue]];
    
    //Enable text fields and segmented-control
    [dueField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [completeSelect setUserInteractionEnabled:YES];
    
    if ([[_assignment completed] boolValue] == NO) //if assignment is not completed
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
    [_assignment setDue_date:[dueField text]];
    [_assignment setName:[nameField text]];
    [_assignment setMark:[formatter numberFromString:[markField text]]];
    [self viewDidLoad];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:dueField]) //bring up date picker when due field is tapped
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
        [self.dueField setInputView:datePicker];
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

//Update the dateField
-(void)updateTextField:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yy HH:mm"];
    UIDatePicker *picker = (UIDatePicker*)self.dueField.inputView;
    self.dueField.text = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:picker.date]];
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
    [_assignment setCompleted:[NSNumber numberWithInteger:[completeSelect selectedSegmentIndex]]];
    [self viewDidLoad];
}
@end
