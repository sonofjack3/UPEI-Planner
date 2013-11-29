//
//  AssignDetailsController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays attributes of a specific assignment.

#import "AssignDetailsController.h"

@interface AssignDetailsController ()

@end

@implementation AssignDetailsController
@synthesize nameField;
@synthesize dueField;
@synthesize markField;
@synthesize completeSelect;

// Initializer using the nib file
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

// Called to load this controller's view
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[_assignment name]];
    
    //Fill text fields and segmented controller with existing assignment data
    [[self dueField]setText:[_assignment due_date]];
    [[self nameField]setText:[_assignment name]];
    [[self markField] setText:[[_assignment mark] stringValue]];
    [completeSelect setSelectedSegmentIndex:[[_assignment completed]integerValue]];
    
    //Enable text fields and segmented-control
    [dueField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [completeSelect setUserInteractionEnabled:YES];
    
    //Enable mark field based on completion status
    if ([[_assignment completed] boolValue] == NO) //if assignment is not completed
    {
        [markField setText:@""];
        [markField setUserInteractionEnabled:NO]; //mark field editable only when assignment has been completed
        [markField setAlpha:0.3]; //"grey out" mark field
    }
    else //assignment is completed
    {
        [markField setUserInteractionEnabled:YES];
        [markField setAlpha:1];
    }
}

// Save user edits to the database
- (void) saveChanges
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_assignment setDue_date:[dueField text]];
    [_assignment setName:[nameField text]];
    [_assignment setMark:[formatter numberFromString:[markField text]]];
    [self viewDidLoad];
}

// Called when a text field is tapped
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

// Called when RETURN is tapped on the keyboard
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; //dismiss keyboard
    return YES;
}

// Called to dismiss keyboard when any other area on the screen is tapped
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self saveChanges];
    [[self view] endEditing:YES];
}

#pragma mark: private methods

// Returns the application delegate
- (AppDelegate *) appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//User edits saved after fields are edited; called when first responder status is resigned
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self saveChanges];
}

// Update the date field after date has been picked
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
