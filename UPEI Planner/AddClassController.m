//
//  AddClassController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-17.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  

#import "AddClassController.h"

@interface AddClassController ()

@end

@implementation AddClassController

// Initializes controller using nib file
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
    
    [[self navigationItem] setTitle:@"Add class"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when RETURN is tapped on keyboard
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; //dismiss keyboard
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

// Action called by _saveButton to save edits to the class
- (void) saveClass
{
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentClass" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    StudentClass *class;
    NSError *error = nil;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    class = [NSEntityDescription insertNewObjectForEntityForName:@"StudentClass" inManagedObjectContext:context];
    
    /* Save user's text field entries to database (StudentClass) */
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [class setClassprefix:[_prefixField text]];
    [class setClassnumber:[formatter numberFromString:[_numberField text]]];
    [class setName:[_nameField text]];
    [class setProfessor:[_profField text]];
    
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
