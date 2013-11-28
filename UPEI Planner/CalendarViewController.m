//
//  CalendarViewController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays an Agenda table which shows all incompleted items.

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController
@synthesize examList;
@synthesize assignList;
@synthesize projectList;

// Default initializer
- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    [[self tabBarItem] setImage:[UIImage imageNamed:@"calendar.png"]]; //set tab bar icon
    [self setTitle:@"Agenda"];
    return self;
}

// Initialize using a specfied table view style
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [[self tabBarItem] setTitle:@"Agenda"];
        [self setTitle:@"Agenda"];
    }
    return self;
}

// Called when this controller's view is loaded
- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Agenda"];
    [[self tableView] reloadData];
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
    return 3; //section for Assignments, section for Exams, section for Projects
}

// Returns the number of rows in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of exams: %d", [examList count]);
    NSLog(@"Number of projects: %d", [projectList count]);
    NSLog(@"Number of assignments: %d", [assignList count]);
    if(section == 0) //exams
        return [examList count];
    else if(section ==1) //assignments
        return [assignList count];
    else if(section ==2) //projects
        return [projectList count];
    return 0;
}

// Set title for each section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Exams";
    }
    else if(section == 1)
    {
        return @"Assignments";
    }
    else if(section == 2)
    {
        return @"Projects";
    }
    return nil;
}

// Configure table cell at given indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"AgendaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy HH:mm"];
    NSDate *dateNow = [NSDate date];
    NSString *now = [dateFormatter stringFromDate:dateNow];
    dateNow = [dateFormatter dateFromString:now];
    NSDate *dueDate;
    NSString *dueDateString;
    NSNumber *completed;
    
    /* Configure each cell */
    switch([indexPath section]){
        case 0:{ //exams
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            Exam *exam = [examList objectAtIndex:[indexPath row]];
            dueDate = [dateFormatter dateFromString:[exam due_date]];
            dueDateString = [exam due_date];
            completed = [exam completed];
            [[cell textLabel] setText:[exam name]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Exam date: %@", dueDateString]];
            break;}
        case 1:{ //assignments
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            Assignment *assign = [assignList objectAtIndex:[indexPath row]];
            dueDate = [dateFormatter dateFromString:[assign due_date]];
            dueDateString = [assign due_date];
            completed = [assign completed];
            [[cell textLabel] setText:[assign name]];
            break;}
        case 2:{ //projects
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            Project *project = [projectList objectAtIndex:[indexPath row]];
            dueDate = [dateFormatter dateFromString:[project due_date]];
            dueDateString = [project due_date];
            completed = [project completed];
            [[cell textLabel] setText:[project name]];
            break;}
    }
    
    if ([indexPath section] != 0) //completion status not shown for exams (section 0)
    {
        /* Configure detailText for each Assignment or Project cell with due date and completed status */
        if (([completed isEqualToNumber:[NSNumber numberWithInt:0]]) &&  ([dueDate compare:dateNow] == NSOrderedDescending)) //if item is not yet completed and not overdue
        {
            [[cell detailTextLabel]setText:[NSString stringWithFormat:@"INCOMPLETE. Due: %@", dueDateString]];
            ([[cell detailTextLabel] setTextColor:[UIColor grayColor]]);
        }
        else if (([completed isEqualToNumber:[NSNumber numberWithInt:0]]) && ([dueDate compare:dateNow] == NSOrderedAscending)) //if item is not completed and is overdue
        {
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"OVERDUE. Due: %@", dueDateString]];
            [[cell detailTextLabel] setTextColor:[UIColor redColor]];
        }
        
        //Completed items are not shown
    }
    
    return cell;
}

// Called when the row at indexPath is tapped
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Selecting an item will bring up that item's particular Details view
    switch ([indexPath section]) {
        case 0: { //exams
            ExamDetailsController *next = [[ExamDetailsController alloc] initWithNibName:@"ExamDetailsController" bundle:nil];
            [next setExam:[examList objectAtIndex:indexPath.row]];
            [[self navigationController] pushViewController:next animated:YES];
            break;
        }
        case 1: { //assignments
            AssignDetailsController *next = [[AssignDetailsController alloc] initWithNibName:@"AssignDetailsController" bundle:nil];
            [next setAssignment:[assignList objectAtIndex:indexPath.row]];
            [[self navigationController] pushViewController:next animated:YES];
            break;
        }
        case 2: { //projects
            ProjectDetailsController *next = [[ProjectDetailsController alloc] initWithNibName:@"ProjectDetailsController" bundle:nil];
            [next setProject:[_projects objectAtIndex:indexPath.row]];
            [[self navigationController] pushViewController:next animated:YES];
        }
    }
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
    examList = [[NSMutableArray alloc]init];
    assignList = [[NSMutableArray alloc]init];
    projectList = [[NSMutableArray alloc]init];
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentClass"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Use NSSortDescriptor to sort classes by name
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%i",fetchedObjects.count);
    
    //Add incomplete items to the arrays examList, projectList and assignList using the complete set of items
    for(int i =0; i<fetchedObjects.count;i++) {
    
        _classes = [[NSArray alloc] initWithObjects:[fetchedObjects objectAtIndex:i], nil];
        _course = [_classes objectAtIndex:0];
        NSLog(@"%i",i );
        
        //Add incomplete exams to array examList
        _exams = [NSMutableArray arrayWithArray:[[_course exam] allObjects]];
        for(int j = 0; j<_exams.count;j++){
            if([[[_exams objectAtIndex:j]completed]intValue] ==0){
            [examList addObject:[_exams objectAtIndex:j]];
                NSLog(@"Exam: %@",[[_exams objectAtIndex:j] name]);}
        }
        
        //Add incomplete projects to array projectList
        _projects = [NSMutableArray arrayWithArray:[[_course project] allObjects]];
        for(int k = 0; k<_projects.count;k++){
            if([[[_projects objectAtIndex:k]completed]intValue] ==0){
            [projectList addObject:[_projects objectAtIndex:k]];
            NSLog(@"Project %@",[[_projects objectAtIndex:k] name]);
            }
        }
        
        //Add incomplete assignments to array assignList
        _assign = [NSMutableArray arrayWithArray:[[_course assignment] allObjects]];
        for(int l = 0; l<_assign.count;l++){
            if([[[_assign objectAtIndex:l]completed]intValue] ==0){
            [assignList addObject:[_assign objectAtIndex:l]];
                NSLog(@"assignment %@",[[_assign objectAtIndex:l] name]);}
            }
        }
    
    //Use NSSortDescriptor to sort agenda items by due date
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]initWithKey:@"due_date" ascending:YES];
    [examList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    [assignList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    [projectList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    [[self tableView] reloadData];
}

// Set text for the table view delete button
- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Mark as complete"; //deleting a row from the agenda view simply marks the corresponding object as complete
}

// Called when the view appears
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadTableData];
}

#pragma mark - Table view delegate

// Specifies editing style for each cell
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete; //all rows deletable
}

// Used here to delete items from the agenda (ie: mark them as complete)
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *ipaths = [NSArray arrayWithObject:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
        
        NSLog(@"row %i",[indexPath row]);
        /* Switch case gets item corresponding to indexPath within the database and marks it as complete, and removes it from the array holding the incomplete items (examList, assignList, projectList) */
        switch([indexPath section]){
            case 0:{ //exams
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exam" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entity];
                NSError *error = nil;
                NSMutableArray *uncompletedExams = [[NSMutableArray alloc] init];
                for(int k = 0; k<_exams.count;k++){
                    if([[[_exams objectAtIndex:k]completed]intValue] ==0){
                        [uncompletedExams addObject:[_exams objectAtIndex:k]];
                    }
                }
                Exam *exam = [uncompletedExams objectAtIndex:[indexPath row]];
                [exam setCompleted:[NSNumber numberWithInteger:1]];
                
                if ([context save:&error])
                {
                    NSLog(@"Saved successfully");
                }
                else
                {
                    NSLog(@"Save error: %@", [error localizedDescription]);
                }
                [tableView deleteRowsAtIndexPaths:ipaths withRowAnimation:UITableViewRowAnimationFade];
                [examList removeObjectAtIndex:[indexPath row]];
                break;}
            case 1:{ //assignments
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Assignment" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entity];
                NSError *error = nil;
                NSMutableArray *uncompletedAssignments = [[NSMutableArray alloc] init];
                for(int k = 0; k<_assign.count;k++){
                    if([[[_assign objectAtIndex:k]completed]intValue] ==0){
                        [uncompletedAssignments addObject:[_assign objectAtIndex:k]];
                    }
                }
                Assignment *assign = [uncompletedAssignments objectAtIndex:[indexPath row]];
                [assign setCompleted:[NSNumber numberWithInteger:1]];
                
                if ([context save:&error])
                {
                    NSLog(@"Saved successfully");
                }
                else
                {
                    NSLog(@"Save error: %@", [error localizedDescription]);
                }
                [tableView deleteRowsAtIndexPaths:ipaths withRowAnimation:UITableViewRowAnimationFade];
                [assignList removeObjectAtIndex:[indexPath row]];
                break;}
            case 2:{ //projects
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entity];
                NSError *error = nil;
                NSMutableArray *uncompletedProjects = [[NSMutableArray alloc] init];
                for(int k = 0; k<_projects.count;k++){
                    if([[[_projects objectAtIndex:k]completed]intValue] ==0){
                        [uncompletedProjects addObject:[_projects objectAtIndex:k]];
                    }
                }
                Project *project = [uncompletedProjects objectAtIndex:[indexPath row]];
                [project setCompleted:[NSNumber numberWithInteger:1]];
                
                if ([context save:&error])
                {
                    NSLog(@"Saved successfully");
                }
                else
                {
                    NSLog(@"Save error: %@", [error localizedDescription]);
                }
                [tableView deleteRowsAtIndexPaths:ipaths withRowAnimation:UITableViewRowAnimationFade];
                [[projectList objectAtIndex:[indexPath row]]setCompleted:[NSNumber numberWithInteger:1]];
                [projectList removeObjectAtIndex:[indexPath row]];
                break;}
        }
        [tableView endUpdates];
    }
}

@end
