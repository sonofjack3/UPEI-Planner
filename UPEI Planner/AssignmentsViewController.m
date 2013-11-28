//
//  AssignmentsViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays all assignments for a course in a table.

#import "AssignmentsViewController.h"

@interface AssignmentsViewController ()

@end

@implementation AssignmentsViewController

// Default initializer
- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

// Initializer using a specified table style
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self setTitle:@"Assignments"];
    }
    return self;
}

// Called to load this controller's view
- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
    //Add button 
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAssignment)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    
    [[self navigationItem] setTitle:@"Assignments"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Returns the number of sections in the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// Returns the number of rows in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of assignments: %d", [_assignments count]);
    return [_assignments count];
}

// Configures the table cell at the given indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AssignmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Assignment *assignment = [_assignments objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[assignment name]];
    
    //Display completed status and due date for each assignment
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy HH:mm"];
    NSDate *dateNow = [NSDate date];
    NSString *now = [dateFormatter stringFromDate:dateNow];
    dateNow = [dateFormatter dateFromString:now];
    NSDate *dueDate = [dateFormatter dateFromString:[assignment due_date]];
    NSLog(@"%@", now);
    NSLog(@"%@", [assignment due_date]);
    if (([[assignment completed] isEqualToNumber:[NSNumber numberWithInt:0]]) &&  ([dueDate compare:dateNow] == NSOrderedDescending)) //if assignment is not yet completed and not overdue
    {
        [[cell detailTextLabel]setText:[NSString stringWithFormat:@"INCOMPLETE. Due: %@", [assignment due_date]]];
        ([[cell detailTextLabel] setTextColor:[UIColor grayColor]]);
    }
    else if ([[assignment completed] isEqualToNumber:[NSNumber numberWithInt:1]]) //assignment is completed
    {
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"COMPLETED. Due: %@", [assignment due_date]]];
        [[cell detailTextLabel] setTextColor:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1]];
    }
    else if (([[assignment completed] isEqualToNumber:[NSNumber numberWithInt:0]]) && ([dueDate compare:dateNow] == NSOrderedAscending))
    {
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"OVERDUE. Due: %@", [assignment due_date]]];
        [[cell detailTextLabel] setTextColor:[UIColor redColor]];
    }
    
    return cell;
    //return nil;
}

#pragma mark - Table view delegate

// Called when row at indexPath is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Push AssignDetailsController on the stack
    AssignDetailsController *next = [[AssignDetailsController alloc] initWithNibName:@"AssignDetailsController" bundle:nil];
    [next setAssignment:[_assignments objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:next animated:YES];

}

#pragma mark - Private methods

// Returns the application delegate
- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Performs a fetch and reloads the table view.
- (void) loadTableData
{
    _assignments = [NSMutableArray arrayWithArray:[[_course assignment] allObjects]];
    [_course setAssignment:[NSSet setWithArray:_assignments]];
    
    // Use NSSortDescriptor to sort assignments by due date
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"due_date" ascending:YES];
    [_assignments sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [[self tableView] reloadData];
}

// Called when the view appears
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadTableData];
}

// Set editing status
- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[self tableView] setEditing:editing animated:YES];
}

// Set editing style per row
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Used here to delete rows from the table view
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _indexPathToBeDeleted = indexPath;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete %@?", [[_assignments objectAtIndex:[indexPath row]] name]] message:nil delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
}

// Called when a row is chosen for deletion (displays an alert view)
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //delete confirmation
    {
        /* Delete object in the database */
        [[self tableView] beginUpdates];
        NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Assignment" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSError *error = nil;
        Assignment *assignmentToDelete = [[context executeFetchRequest:request error:&error] objectAtIndex:[[self indexPathToBeDeleted] row]];
        [context deleteObject:assignmentToDelete];
        [[_course assignment] removeObject:assignmentToDelete];
        if ([context save:&error])
        {
            NSLog(@"Saved successfully");
        }
        else
        {
            NSLog(@"Save error: %@", [error localizedDescription]);
        }
        
        /* Delete corresponding row in the table view */
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:_indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationFade];
        [_assignments removeObjectAtIndex:[_indexPathToBeDeleted row]];
        NSLog(@"%d", [_assignments count]);
        [[self tableView] endUpdates];
    }
}

// Called to add an assignment to the table view and the database
- (void) addAssignment
{
    AddAssignmentController *next = [[AddAssignmentController alloc] initWithNibName:@"AddAssignmentController" bundle:nil];
    [next setCourse:_course];
    [[self navigationController] pushViewController:next animated:YES];
}

@end
