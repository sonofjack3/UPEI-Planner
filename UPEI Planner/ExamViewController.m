//
//  ExamViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Displays all exams for a course in a table view.

#import "ExamViewController.h"

@interface ExamViewController ()

@end

@implementation ExamViewController

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
        [self setTitle:@"Exams"];
    }
    return self;
}

// Called to load this controller's view
- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
    //Add button for adding a new exam
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExam)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    
    [[self navigationItem] setTitle:@"Exams"];
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
    NSLog(@"Number of exams: %d", [_exams count]);
    return [_exams count];
}

// Configures the table cell at the given indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ExamCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Exam *exam = [_exams objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[exam name]];
    
    //Display exam date as cell subtitle
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"Date of exam: %@", [exam due_date]]];
    
    return cell;
}

#pragma mark - Table view delegate

// Called when row at indexPath is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamDetailsController *next = [[ExamDetailsController alloc] initWithNibName:@"ExamDetailsController" bundle:nil];
    [next setExam:[_exams objectAtIndex:indexPath.row]];
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
    _exams = [NSMutableArray arrayWithArray:[[_course exam] allObjects]];
    [_course setExam:[NSSet setWithArray:_exams]];
    
    //Use NSSortDescriptor to sort exams by date
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"due_date" ascending:YES];
    [_exams sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete %@?", [[_exams objectAtIndex:[indexPath row]] name]] message:nil delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
}

// Called when a row is chosen for deletion (displays an alert view)
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //delete confirmation
    {
        /* Delete object in the database */
        [[self tableView] beginUpdates];
        NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exam" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSError *error = nil;
        Exam *examToDelete = [[context executeFetchRequest:request error:&error] objectAtIndex:[[self indexPathToBeDeleted] row]];
        [context deleteObject:examToDelete];
        [[_course exam] removeObject:examToDelete];
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
        [_exams removeObjectAtIndex:[_indexPathToBeDeleted row]];
        NSLog(@"%d", [_exams count]);
        [[self tableView] endUpdates];
    }
}

// Called to add an exam to the table view and the database
- (void) addExam{
    AddExamController *next = [[AddExamController alloc] initWithNibName:@"AddExamController" bundle:nil];
    [next setCourse:_course];
    [[self navigationController] pushViewController:next animated:YES];
}

@end
