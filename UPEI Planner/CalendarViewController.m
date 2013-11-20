//
//  CalendarViewController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-19.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController
@synthesize examList;
@synthesize assignList;
@synthesize projectList;
- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    [[self tabBarItem] setTitle:@"Info View"];
    [self setTitle:@"Agenda"];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [[self tabBarItem] setTitle:@"Info View"];
        [self setTitle:@"Agenda"];
    }
    return self;
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of exams: %d", [examList count]);
    NSLog(@"Number of projects: %d", [projectList count]);
    NSLog(@"Number of assignments: %d", [assignList count]);
    if(section == 0)
        return [examList count];
    else if(section ==1)
        return [assignList count];
    else if(section ==2)
        return [projectList count];
    return 0;
}
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"AgendaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    switch([indexPath section]){
        case 0:{
            // Configure the cell...
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            Exam *exam = [examList objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[exam name]];
            [[cell detailTextLabel]setText:[NSString stringWithFormat:@"Due: %@", [exam due_date]]];
            break;}
        case 1:{
            // Configure the cell...
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            Assignment *assign = [assignList objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[assign name]];
            [[cell detailTextLabel]setText:[NSString stringWithFormat:@"Due: %@", [assign due_date]]];
            break;}
        case 2:{
            // Configure the cell...
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            Project *project = [projectList objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[project name]];
            
            [[cell detailTextLabel]setText:[NSString stringWithFormat:@"Due: %@", [project due_date]]];
            break;}
    }
    
    
    return cell;
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
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Performs a fetch and reloads the table view.
- (void) loadTableData {
    examList = [[NSMutableArray alloc]init];
    assignList = [[NSMutableArray alloc]init];
    projectList = [[NSMutableArray alloc]init];
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
    NSLog(@"%i",fetchedObjects.count);
    for(int i =0; i<fetchedObjects.count;i++) {
    _classes = [[NSArray alloc] initWithObjects:[fetchedObjects objectAtIndex:i], nil];
    
        _course = [_classes objectAtIndex:0];
        NSLog(@"%i",i );
        _exams = [NSMutableArray arrayWithArray:[[_course exam] allObjects]];
        for(int j = 0; j<_exams.count;j++){
            if([[[_exams objectAtIndex:j]completed]intValue] ==0){
            [examList addObject:[_exams objectAtIndex:j]];
                NSLog(@"Exam: %@",[[_exams objectAtIndex:j] name]);}
        }
        
        _projects = [NSMutableArray arrayWithArray:[[_course project] allObjects]];
        for(int k = 0; k<_projects.count;k++){
            if([[[_projects objectAtIndex:k]completed]intValue] ==0){
            [projectList addObject:[_projects objectAtIndex:k]];
            NSLog(@"Project %@",[[_projects objectAtIndex:k] name]);
            }
        }
        _assign = [NSMutableArray arrayWithArray:[[_course assignment] allObjects]];
        for(int l = 0; l<_assign.count;l++){
            if([[[_assign objectAtIndex:l]completed]intValue] ==0){
            [assignList addObject:[_assign objectAtIndex:l]];
                NSLog(@"assignment %@",[[_assign objectAtIndex:l] name]);}
            }
        }
    
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]initWithKey:@"due_date" ascending:YES];
    [examList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    [assignList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    [projectList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
    [[self tableView] reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadTableData];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
        
        
        
        NSLog(@"row %i",[indexPath row]);
        switch([indexPath section]){
            case 0:{
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
            case 1:{
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
            case 2:{
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
