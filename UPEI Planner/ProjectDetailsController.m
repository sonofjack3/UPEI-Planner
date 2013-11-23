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
@synthesize markField;
@synthesize completeSelect;
@synthesize membersField;

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
    [[self nameField]setText:[_project name]];
    [[self membersField]setText:[_project members]];
    [[self markField]setText:[[_project mark] stringValue]];
    [[self membersField]setText:[_project members]];
    [completeSelect setSelectedSegmentIndex:[[_project completed]integerValue]];
    [dateField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [nameField setUserInteractionEnabled:YES];
    [membersField setUserInteractionEnabled:YES];
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
    [_project setName:[nameField text]];
    [_project setMark:[formatter numberFromString:[markField text]]];
    [_project setMembers:[membersField text]];
    [self viewDidLoad];
}

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

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self saveChanges];
    [[self view] endEditing:YES];
}

- (AppDelegate *) appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//User edits saved after fields are edited; called when first responder status is resigned
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:membersField] || [textField isEqual:markField]) //move down all text fields when done editing members field or mark field
    {
        [self animateTextField:textField up:NO];
    }
    [self saveChanges];
}

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

- (IBAction)selectMembers:(id)sender
{
    [[self view] endEditing:YES]; //dismiss any editing that is happening when members button is tapped
    [self saveChanges]; //save any changes that were made before button was tapped
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    NSString *current = self.membersField.text;
    if (current == nil) //if members field is empty
        self.membersField.text = [NSString stringWithFormat:@"%@", name];
    else //members field is not empty; place new name in front of current text
        self.membersField.text = [NSString stringWithFormat:@"%@, %@", current, name];
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
