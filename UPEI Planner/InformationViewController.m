//
//  InformationViewController.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Planner View displays the Student's information (name, ID, picture) and a View Courses button

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController
@synthesize studentArray;
@synthesize InfoView;

// Initializer using the file's nib
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self tabBarItem] setImage:[UIImage imageNamed:@"text-list.png"]]; //set tab bar image for Planner view
        [self setTitle:@"Planner"];
    }
    return self;
}

// Called to load this controller's view
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit Student"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(editStudent)];
    [[self navigationItem] setRightBarButtonItem:edit];
    Student *student = [studentArray objectAtIndex:0]; //get first Student from the Student array
    
    //Set labels and image
    [_nameLabel setText:[student name]];
    [_imageView setImage:[student picture]];
    [_idLabel setText:[[student id]stringValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

// Returns the application delegate
- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Performs a data fetch and reloads the view
- (void) loadData
{
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Construct a fetch request and set Student entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Use NSSortDescriptor to sort by name
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
    else //student already in database; load it from the database
    {
        for (Student *student in fetchedObjects)
        {
            classes = [student courses];
            Student *student = [studentArray objectAtIndex:0];
            [_nameLabel setText:[student name]];
            [_imageView setImage:[student picture]];
            [_idLabel setText:[[student id]stringValue]];
            NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"StudentClass"
                                                       inManagedObjectContext:context];
            [fetchRequest2 setEntity:entity2];
            
            // Use NSSortDescriptor to sort by name
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors2 = [[NSArray alloc] initWithObjects:sortDescriptor2, nil];
            [fetchRequest2 setSortDescriptors:sortDescriptors2];
            
            NSError *error2 = nil;
            NSArray *fetchedObjects2 = [context executeFetchRequest:fetchRequest2 error:&error2];
            
            [_courseLabel setText:[NSString stringWithFormat:@"%i",fetchedObjects2.count]];

        }
    }
    [[self InfoView]reloadInputViews];
        
}

// Called when view appears
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Load the table data //
    [self loadData];
}

// Called when the Edit Student button is tapped
- (void) editStudent
{
    UIViewController *next = [[EditStudentController alloc] initWithNibName:@"EditStudentController" bundle:nil];
    [[self navigationController] pushViewController:next animated:YES]; //push EditStudentController on the stack
}

// Called when the View Courses button is tapped
- (IBAction)viewCourses:(id)sender
{
    CoursesViewController *next = [[CoursesViewController alloc] initWithNibName:@"CoursesViewController" bundle:nil];
    [[self navigationController] pushViewController:next animated:YES]; //push CoursesViewController on the stack
}
@end
