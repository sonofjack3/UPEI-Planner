//
//  InformationViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController
@synthesize studentArray;
@synthesize TableView;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [[self tabBarItem] setTitle:@"Info View"];
        [self setTitle:@"Planner"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit Student"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(editStudent)];
    [[self navigationItem] setRightBarButtonItem:edit];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // The number of Faculties will define the # of rows needed
    int size = 0;
    if(studentArray.count)
        size = studentArray.count;
    return size;
    //return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"StudentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    //[[cell textLabel] setText:[NSString stringWithFormat:@"%d - Puppy", [indexPath row]]];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // Get the faculty
    Student *student = [studentArray objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[student name]];
    //NSLog([student name]);
    // Set the cell's text to the faculty name
    [[cell textLabel] setText:[student name]];
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"Student ID: %@",[student id]]];

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
    UIViewController *next = [[CoursesViewController alloc] initWithNibName:@"CoursesViewController" bundle:nil];
    [[self navigationController] pushViewController:next animated:YES];
    
    //DepartmentViewController *departmentViewController = [self.storyboardinstantiateViewControllerWithIdentifier:@"DeptController"];
    
    // Get the Faculty
    //Faculty *faculty = [facultyArray objectAtIndex:indexPath.row];
    
    //[departmentViewController setFacultyID:[faculty objectID]];
    
    //[[self navigationController] pushViewController:departmentViewController animated:YES];
    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Add an NSSortDescriptor to sort the faculties alphabetically
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    studentArray = [context executeFetchRequest:fetchRequest error:&error];
    if ([studentArray count] == 0) //no student in database; first time app is being used
    {
        [self editStudent]; //bring up the EditStudentController's view
    }
    else
    {
        for (Student *student in fetchedObjects)
        {
            // DisplayFaculty details
            NSLog(@"Student: %@, id: %@", [student name], [student id]);
        
            NSLog(@"\tCourses:");
            NSSet *classes = [student courses];
        }
    }
    [[self tableView] reloadData];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadTableData];
}

- (void) editStudent
{
    UIViewController *next = [[EditStudentController alloc] initWithNibName:@"EditStudentController" bundle:nil];
    [[self navigationController] pushViewController:next animated:YES];
}

@end
