//
//  EditStudentController.m
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-13.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "EditStudentController.h"

@interface EditStudentController ()

@end

@implementation EditStudentController
@synthesize imageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)choosePhoto:(id)sender
{
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=TRUE;
    [self presentViewController:imagePickController animated:YES completion:NULL];
    
}

#pragma mark - When finish shoot

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    imageView.image=image;
    //saveImageBotton.enabled=TRUE;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveStudent)];
    [[self navigationItem] setRightBarButtonItem:_saveButton];
    
    _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    [[self navigationItem] setLeftBarButtonItem:_cancelButton];
    
    [[self navigationItem] setTitle:@"Edit student info"];
    
    /* Disable cancel button if this is the first time the app is opened (no student in database) and enable otherwise*/
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error = nil;
    if ([[context executeFetchRequest:request error:&error] count] == 0) //no student in database
        [_cancelButton setEnabled:NO];
    else {//a student is in the database
        [_cancelButton setEnabled:YES];
        NSArray *studentArray = [context executeFetchRequest:request error:&error];
        Student *student = [studentArray objectAtIndex:0];
        [_idField setText:[[student id]stringValue]];
        [_nameField setText:[student name]];
        [imageView setImage:[student picture]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

#pragma mark - private methods

- (AppDelegate *) appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Action called by _saveButton to save edits to the Student
- (void) saveStudent
{
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    Student *student;
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    error = nil;
    NSArray *studentArray = [context executeFetchRequest:request error:&error];
    
    if(studentArray.count > 0) //if there is a student in the database
    {
        student = [studentArray objectAtIndex:0];
    }
    else //there are no students and this is the first time the app is being started
    {
        student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
    }
    
    /* Save user's text field entries to database (Student) */
    [student setName:[_nameField text]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [student setId:[formatter numberFromString:[_idField text]]];
    [student setPicture:[imageView image]];
    
    if ([context save:&error])
    {
        NSLog(@"Saved successfully");
    }
    else
    {
        NSLog(@"Save error: %@", [error localizedDescription]);
    }
    
    [self dismiss];
}

- (void) dismiss
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
