//
//  CoursesViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-16.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays a table view of the Student's courses

#import "CoursesViewController.h"

@interface CoursesViewController ()

@end

@implementation CoursesViewController

// Initializer method
- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

// Initializer method using a particular table style
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self setTitle:@"Classes"];
    }
    return self;
}

// Called to load this controller's view
- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
    //Add button for adding courses
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClass)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    
    [[self navigationItem] setTitle:@"Classes"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Returns the number of sections in this table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Returns the number of rows in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of classes: %d", [_classes count]);
    return [_classes count];
}

// Sets up the table view's cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ClassCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    StudentClass *class = [_classes objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[class name]];
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"%@ %@", [class classprefix], [class classnumber]]];
    
    return cell;
}

#pragma mark - Table view delegate

// Called when row at indexPath is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleCourseViewController *next = [[SingleCourseViewController alloc] initWithNibName:@"SingleCourseViewController" bundle:nil];
    [next setRowNumber:[indexPath row]]; //pass row number to SingleCourseViewController to indicate the course at the given row in the database's array
    
    /* Pass the course prefix and number as a single string (simply used as the title of the single course view */
    NSString *prefix = [[_classes objectAtIndex:[indexPath row]] classprefix];
    NSString *number = [prefix stringByAppendingFormat:@" %@", [[_classes objectAtIndex:[indexPath row]] classnumber]];
    [next setClassID:number];
    
    /* Pass the course at the given row */
    [next setCourse:[_classes objectAtIndex:[indexPath row]]];
    
    /* Push the single view controller on the stack */
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
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentClass"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Use NSSortDescriptor to sort courses by name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    _classes = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];

    [[self tableView] reloadData];
}

// Called when view appears
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadTableData];
}

// Sets editing status
- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[self tableView] setEditing:editing animated:YES];
}

// Set editing style per row
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete; //all rows (courses) can be deleted
}

// Used here to delete rows from the table view
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _indexPathToBeDeleted = indexPath;
        _deleteAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete %@ and all associated data?", [[_classes objectAtIndex:[indexPath row]] name]] message:nil delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
        [_deleteAlert show];
    }
}

// Called when a row is chosen for deletion (diplays an alert view)
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:_deleteAlert])
    {
<<<<<<< HEAD
        if (buttonIndex == 0) //delete confirmation
=======
        /* Delete object in the database */
        [[self tableView] beginUpdates];
        NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentClass" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSError *error = nil;
        StudentClass *classToDelete = [[context executeFetchRequest:request error:&error] objectAtIndex:[[self indexPathToBeDeleted] row]];
        [context deleteObject:classToDelete];
        if ([context save:&error])
>>>>>>> 58478260c9d4e919bf310df5db8e85d63a21c937
        {
            /* Delete object in the database */
            [[self tableView] beginUpdates];
            NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentClass" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            NSError *error = nil;
            StudentClass *classToDelete = [[context executeFetchRequest:request error:&error] objectAtIndex:[[self indexPathToBeDeleted] row]];
            [context deleteObject:classToDelete];
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
            [_classes removeObjectAtIndex:[_indexPathToBeDeleted row]];
            [[self tableView] endUpdates];
        }
<<<<<<< HEAD
=======
        else
        {
            NSLog(@"Save error: %@", [error localizedDescription]);
        }
        
        /* Delete corresponding row in the table view */
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:_indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationFade];
        [_classes removeObjectAtIndex:[_indexPathToBeDeleted row]];
        [[self tableView] endUpdates];
>>>>>>> 58478260c9d4e919bf310df5db8e85d63a21c937
    }
}

// Called to add a class to the table view and the database
- (void) addClass
{
<<<<<<< HEAD
    NSLog(@"%i", [_classes count]);
    if ([_classes count] >= MAX_COURSES) //if user has reached max number of courses, display alert
    {
        _maxAlert = [[UIAlertView alloc] initWithTitle:@"Maximum of 5 courses reached. Swipe rows to delete courses." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_maxAlert show];
    }
    else //less than max number of courses is present, allow course addition
    {
        UIViewController *next = [[AddClassController alloc] initWithNibName:@"AddClassController" bundle:nil];
        [[self navigationController] pushViewController:next animated:YES]; //push AddClassController on the stack
    }
=======
    UIViewController *next = [[AddClassController alloc] initWithNibName:@"AddClassController" bundle:nil];
    [[self navigationController] pushViewController:next animated:YES]; //push AddClassController on the stack
>>>>>>> 58478260c9d4e919bf310df5db8e85d63a21c937
}
@end
