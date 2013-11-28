//
//  AddAssignmentController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "AddAssignmentController.h"

@interface AddAssignmentController ()

@end

@implementation AddAssignmentController

// Initializer using the nib file
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Called to load this controller's view
- (void)viewDidLoad
{
    [super viewDidLoad];

    //Save button for saving user inputs
    _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveClass)];
    [[self navigationItem] setRightBarButtonItem:_saveButton];
    
    //Cancel button for cancelling add operation
    _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    [[self navigationItem] setLeftBarButtonItem:_cancelButton];

    [[self navigationItem] setTitle:@"Add Assignment"];
    
    //Bring up date picker when date field is tapped
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateField setInputView:datePicker];
}

// Update the date field after date has been picked
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

// Called when RETURN is tapped on the keyboard
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Called to dismiss keyboard when any other area on the screen is tapped
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

#pragma mark - private methods

// Returns the application delegate
- (AppDelegate *) appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Action called by _saveButton to save edits to the Student
- (void) saveClass
{
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Assignment" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error = nil;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    Assignment *assignment = [NSEntityDescription insertNewObjectForEntityForName:@"Assignment" inManagedObjectContext:context];
    
    /* Save user's text field entries to database (Assignment) */
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [assignment setName:[_nameField text]];
    [assignment setDue_date:[_dateField text]];
    [assignment setClasses:_course];
    [assignment setCompleted:[NSNumber numberWithInt:0]]; //set new assignment to incomplete
    
    [[_course assignment] addObject:assignment];
    NSLog(@"%@", [_course assignment]);
    
    if ([context save:&error])
    {
        NSLog(@"Saved successfully");
    }
    else
    {
        NSLog(@"Save error: %@", [error localizedDescription]);
    }
    
    [self dismiss];
}

// Called when cancel button is tapped; pops this controller off the stack
- (void) dismiss
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
