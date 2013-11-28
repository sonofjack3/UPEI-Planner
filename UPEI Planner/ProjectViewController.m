//
//  ProjectsViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays all projects for a course in a table view.

#import "ProjectViewController.h"

@interface ProjectViewController ()

@end

@implementation ProjectViewController

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
        [self setTitle:@"Projects"];
    }
    return self;
}

// Called to load this controller's view
- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
    //Add button for adding a new project
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProject)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    
    [[self navigationItem] setTitle:@"Projects"];
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
    return 1;
}

// Returns the number of rows in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Number of projects: %d", [_projects count]);
    return [_projects count];
}

// Configures the table cell at the given indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Project *project = [_projects objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[project name]];
    
    //Display completed status and due date for each project as a cell subtitle
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy HH:mm"];
    NSDate *dateNow = [NSDate date];
    NSString *now = [dateFormatter stringFromDate:dateNow];
    dateNow = [dateFormatter dateFromString:now];
    NSDate *dueDate = [dateFormatter dateFromString:[project due_date]];
    NSLog(@"%@", now);
    NSLog(@"%@", [project due_date]);
    if (([[project completed] isEqualToNumber:[NSNumber numberWithInt:0]]) &&  ([dueDate compare:dateNow] == NSOrderedDescending)) //if assignment is not yet completed and not overdue
    {
        [[cell detailTextLabel]setText:[NSString stringWithFormat:@"INCOMPLETE. Due: %@", [project due_date]]];
        ([[cell detailTextLabel] setTextColor:[UIColor grayColor]]);
    }
    else if ([[project completed] isEqualToNumber:[NSNumber numberWithInt:1]]) //assignment is completed
    {
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"COMPLETED. Due: %@", [project due_date]]];
        [[cell detailTextLabel] setTextColor:[UIColor colorWithRed:0 green:0.6 blue:0 alpha:1]];
    }
    else if (([[project completed] isEqualToNumber:[NSNumber numberWithInt:0]]) && ([dueDate compare:dateNow] == NSOrderedAscending)) //project is incomplete and overdue
    {
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"OVERDUE. Due: %@", [project due_date]]];
        [[cell detailTextLabel] setTextColor:[UIColor redColor]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

// Called when row at indexPath is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Push ProjectDetailsController on the stack
    ProjectDetailsController *next = [[ProjectDetailsController alloc] initWithNibName:@"ProjectDetailsController" bundle:nil];
    [next setProject:[_projects objectAtIndex:indexPath.row]];
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
    _projects = [NSMutableArray arrayWithArray:[[_course project] allObjects]];
    [_course setProject:[NSSet setWithArray:_projects]];
    
    //Use NSSortDescriptor to sort projects by due date
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"due_date" ascending:YES];
    [_projects sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
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
    return UITableViewCellEditingStyleDelete; //all rows deletable
}

// Used here to delete rows from the table view
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _indexPathToBeDeleted = indexPath;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete %@?", [[_projects objectAtIndex:[indexPath row]] name]] message:nil delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
}

// Called when a row is chosen for deletion (displays an alert view)
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //delete confirmation
    {
        /* Delete object in database */
        [[self tableView] beginUpdates];
        NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSError *error = nil;
        Project *projectToDelete = [[context executeFetchRequest:request error:&error] objectAtIndex:[[self indexPathToBeDeleted] row]];
        [context deleteObject:projectToDelete];
        [[_course project] removeObject:projectToDelete];
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
        [_projects removeObjectAtIndex:[_indexPathToBeDeleted row]];
        NSLog(@"%d", [_projects count]);
        [[self tableView] endUpdates];
    }
}

// Called to add a project to the table view and the database
- (void) addProject
{
    AddProjectController *next = [[AddProjectController alloc] initWithNibName:@"AddProjectController" bundle:nil];
    [next setCourse:_course];
    [[self navigationController] pushViewController:next animated:YES];
}

@end
