//
//  CoursesViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-16.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "CoursesViewController.h"

@interface CoursesViewController ()

@end

@implementation CoursesViewController

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
        [self setTitle:@"Classes"];
    }
    return self;
}

- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Number of classes: %d", [_classes count]);
    return [_classes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ClassCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    StudentClass *class = [_classes objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[class name]];
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"%@ %@", [class classprefix], [class classnumber]]];
    
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
    SingleCourseViewController *next = [[SingleCourseViewController alloc] initWithNibName:@"SingleCourseViewController" bundle:nil];
    [next setRowNumber:[indexPath row]];
    NSString *prefix = [[_classes objectAtIndex:[indexPath row]] classprefix];
    NSString *number = [prefix stringByAppendingFormat:@" %@", [[_classes objectAtIndex:[indexPath row]] classnumber]];
    [next setClassID:number];
    [next setCourse:[_classes objectAtIndex:[indexPath row]]];
    [[self navigationController] pushViewController:next animated:YES];
}

#pragma mark - Private methods
// A helper method to get the appDelegate
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Performs a fetch and reloads the table view.
- (void) loadTableData {
    
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentClass"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Add an NSSortDescriptor to sort the faculties alphabetically
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    _classes = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];

    for (StudentClass *class in fetchedObjects)
    {
        // DisplayFaculty details
        /*NSLog(@"Class Name: %@, Class Number: %@", [class name], [class classnumber]);
            
        NSLog(@"\tCourses:");*/
        //NSSet *classes = [student courses];
    }
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
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentClass" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSError *error = nil;
        StudentClass *classToDelete = [[context executeFetchRequest:request error:&error] objectAtIndex:[indexPath row]];
        [context deleteObject:classToDelete];
        if ([context save:&error])
        {
            NSLog(@"Saved successfully");
        }
        else
        {
            NSLog(@"Save error: %@", [error localizedDescription]);
        }
        [tableView deleteRowsAtIndexPaths:ipaths withRowAnimation:UITableViewRowAnimationFade];
        [_classes removeObjectAtIndex:[indexPath row]];
        NSLog(@"%d", [_classes count]);
        [tableView endUpdates];
    }
}

- (void) addClass
{
    UIViewController *next = [[AddClassController alloc] initWithNibName:@"AddClassController" bundle:nil];
    [[self navigationController] pushViewController:next animated:YES];
}
@end
