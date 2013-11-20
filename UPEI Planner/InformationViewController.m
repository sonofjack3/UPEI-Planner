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
@synthesize InfoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    Student *student = [studentArray objectAtIndex:0];
    [_nameLabel setText:[student name]];
    //NSLog([student name]);
    // Set the cell's text to the faculty name
    [_imageView setImage:[student picture]];
    [_idLabel setText:[[student id]stringValue]];
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
    NSSet *classes;
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

            classes = [student courses];
            Student *student = [studentArray objectAtIndex:0];
            [_nameLabel setText:[student name]];
            //NSLog([student name]);
            // Set the cell's text to the faculty name
            [_imageView setImage:[student picture]];
            [_idLabel setText:[[student id]stringValue]];
            NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"StudentClass"
                                                       inManagedObjectContext:context];
            [fetchRequest2 setEntity:entity2];
            
            // Add an NSSortDescriptor to sort the faculties alphabetically
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors2 = [[NSArray alloc] initWithObjects:sortDescriptor2, nil];
            [fetchRequest2 setSortDescriptors:sortDescriptors2];
            
            NSError *error2 = nil;
            NSArray *fetchedObjects2 = [context executeFetchRequest:fetchRequest2 error:&error2];
            
            [_courseLabel setText:[NSString stringWithFormat:@"%i",fetchedObjects2.count]];

            
        }
    }
    //[[self tableView] reloadData];
    [[self InfoView]reloadInputViews];
        
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

- (IBAction)viewCourses:(id)sender {
    UIViewController *next = [[CoursesViewController alloc] initWithNibName:@"CoursesViewController" bundle:nil];
    [[self navigationController] pushViewController:next animated:YES];
}
@end
