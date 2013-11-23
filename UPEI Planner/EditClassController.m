//
//  EditClassController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "EditClassController.h"

@interface EditClassController ()

@end

@implementation EditClassController

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
    
    _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveClass)];
    [[self navigationItem] setRightBarButtonItem:_saveButton];
    
    _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    [[self navigationItem] setLeftBarButtonItem:_cancelButton];
    
    [[self navigationItem] setTitle:@"Edit class"];
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentClass" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    StudentClass *class;
    NSError *error = nil;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    class = [[context executeFetchRequest:request error:&error] objectAtIndex:_rowNumber];
    [_prefixField setText:[class classprefix]];
    [_numberField setText:[[class classnumber]stringValue]];
    [_nameField setText:[class name]];
    [_profField setText:[class professor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

#pragma mark - private methods

- (AppDelegate *) appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Action called by _saveButton to save edits to the Student
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
    
    class = [[context executeFetchRequest:request error:&error] objectAtIndex:_rowNumber];
    
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

- (void) dismiss
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
