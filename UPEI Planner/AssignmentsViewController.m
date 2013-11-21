//
//  AssignmentsViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "AssignmentsViewController.h"

@interface AssignmentsViewController ()

@end

@implementation AssignmentsViewController

- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self setTitle:@"Assignments"];
    }
    return self;
}

- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Number of assignments: %d", [_assignments count]);
    return [_assignments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AssignmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    Assignment *assignment = [_assignments objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[assignment name]];
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"%@", [assignment due_date]]];
    
    return cell;
    //return nil;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*SingleCourseViewController *next = [[SingleCourseViewController alloc] initWithNibName:@"SingleCourseViewController" bundle:nil];
    [next setRowNumber:[indexPath row]];
    NSString *prefix = [[_classes objectAtIndex:[indexPath row]] classprefix];
    NSString *number = [prefix stringByAppendingFormat:@" %@", [[_classes objectAtIndex:[indexPath row]] classnumber]];
    [next setClassID:number];
    [[self navigationController] pushViewController:next animated:YES];*/
    AssignDetailsController *next = [[AssignDetailsController alloc] initWithNibName:@"AssignDetailsController" bundle:nil];
    [next setAssignment:[_assignments objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:next animated:YES];

}

#pragma mark - Private methods
// A helper method to get the appDelegate
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Performs a fetch and reloads the table view.
- (void) loadTableData {
    _assignments = [NSMutableArray arrayWithArray:[[_course assignment] allObjects]];
    
    [_course setAssignment:[NSSet setWithArray:_assignments]];
    [[self tableView] reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadTableData];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[self tableView] setEditing:editing animated:YES];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _indexPathToBeDeleted = indexPath;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete %@?", [[_assignments objectAtIndex:[indexPath row]] name]] message:nil delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //delete confirmation
    {
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
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:_indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationFade];
        [_assignments removeObjectAtIndex:[_indexPathToBeDeleted row]];
        NSLog(@"%d", [_assignments count]);
        [[self tableView] endUpdates];
    }
}

- (void) addAssignment
{
    AddAssignmentController *next = [[AddAssignmentController alloc] initWithNibName:@"AddAssignmentController" bundle:nil];
    [next setCourse:_course];
    [[self navigationController] pushViewController:next animated:YES];
}

@end
