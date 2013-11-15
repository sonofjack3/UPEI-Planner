//
//  EditStudentController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-13.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "EditStudentController.h"

@interface EditStudentController ()

@end

@implementation EditStudentController

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
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(editStudent)];
    [[self navigationItem] setRightBarButtonItem:save];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    [[self navigationItem] setLeftBarButtonItem:cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (AppDelegate *) appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) editStudent
{
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    Student *student;
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    error = nil;
    NSArray *studentArray = [context executeFetchRequest:request error:&error];
    
    if(studentArray.count > 0) {
        
        student = [studentArray objectAtIndex:0];
    }
    else {
        student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [student setName:[_nameField text]];
    //NSLog(@"%@",[formatter numberFromString:[_idField text]]);
    [student setId:[formatter numberFromString:[_idField text]]]; //not updating properly?
    
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
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

@end
