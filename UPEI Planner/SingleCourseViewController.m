//
//  SingleCourseViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays the information for a single course, and rows for assignments, projects and exams.

#import "SingleCourseViewController.h"

@interface SingleCourseViewController ()

@end

@implementation SingleCourseViewController

// Initialize with a particular table view style
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self setTitle:_classID];
    }
    
    return self;
}

// Called to load this controller's view
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Edit button to allow editing of course information
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
}

#pragma mark - Table view data source

// Returns the number of sections in this table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// Returns the number of rows in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

// Sets up the table view's cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath row] != 0) //any row except the first
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch ([indexPath row])
    {
        case 0: //course description
            [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@: %@", [_course classprefix], [_course classnumber], [_course name]]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Professor: %@", [_course professor]]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //course description is not selectable
            break;
        case 1: //Assignments row
            [[cell textLabel] setText:@"Assignments"];
            break;
        case 2: //Projects row
            [[cell textLabel] setText:@"Projects"];
            break;
        case 3: //Exams row
            [[cell textLabel] setText:@"Exams"];
            break;
    }
    
    return cell;
}

// Sets the height for each cell in the table view
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row])
    {
        case 0: //Course description row
            return 60;
            break;
        default: //Assignments, Projects, Exams rows
            return 44;
            break;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssignmentsViewController *assignsController;
    ProjectViewController *projectsController;
    ExamViewController *examsController;
    switch ([indexPath row]) {
        case 1: //Assignments
            assignsController = [[AssignmentsViewController alloc] init];
            [assignsController setCourse:_course];
            [[self navigationController] pushViewController:assignsController animated:YES];
            break;
        case 2: //Projects
            projectsController = [[ProjectViewController alloc] init];
            [projectsController setCourse:_course];
            [[self navigationController] pushViewController:projectsController animated:YES];
            break;
        case 3: //Exams
            examsController = [[ExamViewController alloc] init];
            [examsController setCourse:_course];
            [[self navigationController] pushViewController:examsController animated:YES];
            break;
    }
}

#pragma mark - Private methods

// Returns the application delegate
- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Called when the Edit Class button is tapped
- (void) editClass
{
    //Push the EditClassController on the stack
    EditClassController *next = [[EditClassController alloc] init];
    [next setRowNumber:_rowNumber];
    [[self navigationController] pushViewController:next animated:YES];
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
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    _course = [fetchedObjects objectAtIndex:_rowNumber];
    
    [[self tableView] reloadData];
}

// Called when the view appears
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadTableData];
}

@end
