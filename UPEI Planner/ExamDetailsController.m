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
@synthesize markField;
@synthesize completeSelect;

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
    [self setTitle:[_exam name]];
    [[self dateField]setText:[_exam due_date]];
    [[self weightField]setText:[[_exam weight]stringValue]];
    [[self nameField]setText:[_exam name]];
    [[self markField]setText:[[_exam mark] stringValue]];
    [completeSelect setSelectedSegmentIndex:[[_exam completed]integerValue]];
    [dateField setUserInteractionEnabled:YES];
    [weightField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [completeSelect setUserInteractionEnabled:YES];
    if ([[_exam completed] boolValue] == NO) //if assignment is not completed
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_exam setDue_date:[dateField text]];
    [_exam setWeight:[formatter numberFromString:[weightField text]]];
    [_exam setName:[nameField text]];
    [_exam setMark:[formatter numberFromString:[markField text]]];
    [self viewDidLoad];
}

-(void)updateTextField:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yy HH:mm"];
    UIDatePicker *picker = (UIDatePicker*)self.dateField.inputView;
    self.dateField.text = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:picker.date]];
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
