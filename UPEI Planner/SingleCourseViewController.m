//
//  SingleCourseViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "SingleCourseViewController.h"

@interface SingleCourseViewController ()

@end

@implementation SingleCourseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self setTitle:_classID];
    }
    
    NSString *string = [NSString stringWithFormat:@"Hey"];
    [_course setAssignment:[[NSMutableSet alloc] initWithObjects:string, nil]];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit Class"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(editClass)];
    [[self navigationItem] setRightBarButtonItem:edit];
    
    [[self navigationItem] setTitle:_classID];
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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    switch ([indexPath row])
    {
        case 0: //course description
            [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@: %@", [_course classprefix], [_course classnumber], [_course name]]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Professor: %@", [_course professor]]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //course description is not selectable
            break;
        case 1:
            [[cell textLabel] setText:@"Assignments"];
            break;
        case 2:
            [[cell textLabel] setText:@"Projects"];
            break;
        case 3:
            [[cell textLabel] setText:@"Exams"];
            break;
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row])
    {
        case 0:
            return 60;
            break;
        default:
            return 44;
            break;
    }
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
    AssignmentsViewController *assignsController;
    //ProjectsViewController *projectsController;
    //ExamsViewController *examsController;
    switch ([indexPath row]) {
        case 1: //Assignments
        {
            assignsController = [[AssignmentsViewController alloc] init];
            [assignsController setCourse:_course];
            [[self navigationController] pushViewController:assignsController animated:YES];
            break;
        }
        case 2: //Projects
            
            break;
        case 3: //Exams
            
            break;
    }
}

// A helper method to get the appDelegate
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) editClass
{
    EditClassController *next = [[EditClassController alloc] init];
    [next setRowNumber:_rowNumber];
    [[self navigationController] pushViewController:next animated:YES];
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
    _classes = [[NSArray alloc] initWithObjects:[fetchedObjects objectAtIndex:_rowNumber], nil];
    _course = [_classes objectAtIndex:0];
    
    [[self tableView] reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadTableData];
}

@end
