//
//  ProjectsViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-18.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "ExamViewController.h"

@interface ExamViewController ()

@end

@implementation ExamViewController

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
        [self setTitle:@"Exams"];
    }
    return self;
}

- (void)viewDidLoad
{
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [super viewDidLoad];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Number of exams: %d", [_exams count]);
    return [_exams count];
}

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
    
    
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"Date of exam: %@", [exam due_date]]];
    
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
    ExamDetailsController *next = [[ExamDetailsController alloc] initWithNibName:@"ExamDetailsController" bundle:nil];
    [next setExam:[_exams objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:next animated:YES];
}

#pragma mark - Private methods
// A helper method to get the appDelegate
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Performs a fetch and reloads the table view.
- (void) loadTableData {
    _exams = [NSMutableArray arrayWithArray:[[_course exam] allObjects]];
    [_course setExam:[NSSet setWithArray:_exams]];
    
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]initWithKey:@"due_date" ascending:YES];
    [_exams sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete %@?", [[_exams objectAtIndex:[indexPath row]] name]] message:nil delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //delete confirmation
    {
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
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:_indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationFade];
        [_exams removeObjectAtIndex:[_indexPathToBeDeleted row]];
        NSLog(@"%d", [_exams count]);
        [[self tableView] endUpdates];
    }
}

- (void) addExam{
    AddExamController *next = [[AddExamController alloc] initWithNibName:@"AddExamController" bundle:nil];
    [next setCourse:_course];
    [[self navigationController] pushViewController:next animated:YES];
}

@end
