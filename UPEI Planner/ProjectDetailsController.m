//
//  ProjectDetailsController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays attributes of a specific project.

#import "ProjectDetailsController.h"

@interface ProjectDetailsController ()

@end

@implementation ProjectDetailsController

@synthesize nameField;
@synthesize dateField;
@synthesize markField;
@synthesize completeSelect;
@synthesize membersField;

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
    [self setTitle:[_project name]];
    
    //Fill text fields and segmented controller with existing project data
    [[self dateField]setText:[_project due_date]];
    [[self nameField]setText:[_project name]];
    [[self membersField]setText:[_project members]];
    [[self markField]setText:[[_project mark] stringValue]];
    [[self membersField]setText:[_project members]];
    [completeSelect setSelectedSegmentIndex:[[_project completed]integerValue]];
    
    //Enable text fields and segmented-control
    [dateField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [membersField setUserInteractionEnabled:YES];
    [completeSelect setUserInteractionEnabled:YES];
    
    //Enable mark field based on completion status
    if ([[_project completed] boolValue] == NO) //if assignment is not completed
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
    [_project setDue_date:[dateField text]];
    [_project setName:[nameField text]];
    [_project setMark:[formatter numberFromString:[markField text]]];
    [_project setMembers:[membersField text]];
    [self viewDidLoad];
}

// Called when a text field is tapped
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:membersField] || [textField isEqual:markField]) //move up all text fields when member field or mark field is tapped
    {
        [self animateTextField:textField up:YES];    
    }
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

// User edits saved after fields are edited; called when first responder status is resigned
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:membersField] || [textField isEqual:markField]) //move down all text fields when done editing members field or mark field
    {
        [self animateTextField:textField up:NO];
    }
    [self saveChanges];
}

// Move up text field
- (void) animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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

// Called when segmented control is changed
- (IBAction)completedChanged:(id)sender
{
    [_project setCompleted:[NSNumber numberWithInteger:[completeSelect selectedSegmentIndex]]];
    [self viewDidLoad];
}

// Called when Add Members from Address Book button is tapped
- (IBAction)selectMembers:(id)sender
{
    [[self view] endEditing:YES]; //dismiss any editing that is happening when members button is tapped
    [self saveChanges]; //save any changes that were made before button was tapped
    
    //Display people picker
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
}

// Cancel people picker
- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Dismiss people picker after a contact is chosen
- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}

// Let delegate handle person selection
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

// Fill text field with Contact name chosen from Address Book
- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    NSString *current = self.membersField.text;
    if (current == nil) //if members field is empty
        self.membersField.text = [NSString stringWithFormat:@"%@", name];
    else //members field is not empty; place new name in front of current text
        self.membersField.text = [NSString stringWithFormat:@"%@, %@", name, current];
    [self saveChanges];
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    CFRelease(phoneNumbers);
}

@end
