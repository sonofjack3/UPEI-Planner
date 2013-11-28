//
//  ExamDetailsController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays attributes of a specific exam.

#import "ExamDetailsController.h"

@interface ExamDetailsController ()

@end

@implementation ExamDetailsController
@synthesize nameField;
@synthesize dateField;
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
    [self setTitle:[_exam name]];
    
    //Fill text fields and segmented controller with existing exam data
    [[self dateField]setText:[_exam due_date]];
    [[self nameField]setText:[_exam name]];
    [[self markField]setText:[[_exam mark] stringValue]];
    [completeSelect setSelectedSegmentIndex:[[_exam completed]integerValue]];
    
    //Enable text fields and segmented-control
    [dateField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [completeSelect setUserInteractionEnabled:YES];
    
    //Enable mark field based on completion status
    if ([[_exam completed] boolValue] == NO) //if exam is not completed
    {
        [markField setText:@""];
        [markField setUserInteractionEnabled:NO]; //mark field editable only when exam has been completed
        [markField setAlpha:0.3]; //"grey out" mark field
    }
    else //exam is completed
    {
        [markField setUserInteractionEnabled:YES];
        [markField setAlpha:1];
    }
}

// Called when a text field is tapped
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

// Called when RETURN is tapped on the keyboard
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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

// Save user edits to the database
- (void) saveChanges
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_exam setDue_date:[dateField text]];
    [_exam setName:[nameField text]];
    [_exam setMark:[formatter numberFromString:[markField text]]];
    [self viewDidLoad];
}

// Update the date field after date has been picked
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
- (IBAction)completedChange:(id)sender
{
    [_exam setCompleted:[NSNumber numberWithInteger:[completeSelect selectedSegmentIndex]]];
    [self viewDidLoad];
}
@end
