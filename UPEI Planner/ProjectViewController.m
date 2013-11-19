//
//  ProjectsViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "ProjectViewController.h"

@interface ProjectViewController ()

@end

@implementation ProjectViewController

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
        [self setTitle:@"Projects"];
    }
    return self;
}

- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Number of classes: %d", [_projects count]);
    return [_projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
   Project *project = [_projects objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[project name]];
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"%@", [project due_date]]];
    
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
    ProjectDetailsController *next = [[ProjectDetailsController alloc] initWithNibName:@"ProjectDetailsController" bundle:nil];
    [next setProject:[_projects objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:next animated:YES];
}

#pragma mark - Private methods
// A helper method to get the appDelegate
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Performs a fetch and reloads the table view.
- (void) loadTableData {
    
    _projects = [NSMutableArray arrayWithArray:[[_course project] allObjects]];
    
    [_course setProject:[NSSet setWithArray:_projects]];
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
    NSArray *ipaths = [NSArray arrayWithObject:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSError *error = nil;
        Project *projectToDelete = [[context executeFetchRequest:request error:&error] objectAtIndex:[indexPath row]];
        [context deleteObject:projectToDelete];
        if ([context save:&error])
        {
            NSLog(@"Saved successfully");
        }
        else
        {
            NSLog(@"Save error: %@", [error localizedDescription]);
        }
        [tableView deleteRowsAtIndexPaths:ipaths withRowAnimation:UITableViewRowAnimationFade];
        [_projects removeObjectAtIndex:[indexPath row]];
        NSLog(@"%d", [_projects count]);
        [tableView endUpdates];
    }
}

- (void) addProject{
    AddProjectController *next = [[AddProjectController alloc] initWithNibName:@"AddProjectController" bundle:nil];
    [next setCourse:_course];
    [[self navigationController] pushViewController:next animated:YES];
}

@end
