//
//  AppDelegate.m
//  UPEI Planner
//
//  Created by Evan Jackson on 2013-11-04.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import "AppDelegate.h"
#import "InformationViewController.h"
#import "CalendarViewController.h"
#import "MoodleViewController.h"

#import "Student.h"
#import "Assignment.h"
#import "Exam.h"
#import "StudentClass.h"
#import "Project.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Create view controller for each screen
    InformationViewController *info = [[InformationViewController alloc] init];
    CalendarViewController *calendar = [[CalendarViewController alloc] init];
    MoodleViewController *moodle = [[MoodleViewController alloc] init];
    
    //Create a tab bar view controller with tabs for each of the above three views
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:info, calendar, moodle, nil];
    [tabBar setViewControllers:viewControllers];
    
    [[self window] setRootViewController:tabBar];
    
    // Override point for customization after application launch
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //[self create];
    //[self read];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (void) create {
    // Get the context
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create and configure the Faculty entity and set its attributes
    Student *Kyle = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
    [Kyle setName:@"Kyle Pineau"];
    [Kyle setId:[NSNumber numberWithInt:1]];
    
    // Create and configure the Department entity and set its attributes
    StudentClass *CSC212 = [NSEntityDescription insertNewObjectForEntityForName:@"StudentClass" inManagedObjectContext:context];
    [CSC212 setName:@"Non Traditional Programming"];
    [CSC212 setProfessor:@"Stephen Howard"];
    [CSC212 setClassprefix:@"CSC"];
    [CSC212 setClassnumber:[NSNumber numberWithInt:212]];
    
    // Create and configure the Course entity and set its attributes
    
    
    // Set relationships (including reverse relationships)
    [Kyle addCoursesObject:CSC212];
    [CSC212 setStudent:Kyle];
    
    
    // Tell the context object to save everything
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"Saved successfully!");
    } else {
        NSLog(@"Oops, save error: %@", [error userInfo]);
    }
    
}
- (void) read {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Build a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (Student *student in fetchedObjects) {
        // DisplayFaculty details
        NSLog(@"Student: %@, id: %@", [student name], [student id]);
        
        NSLog(@"\tCourses:");
        NSSet *classes = [student courses];
        
        
        // Use these 3 lines (instead of the 1 line below) to sort departments alphabetically by name
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortList = [classes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
        for (StudentClass *class in sortList) {
            
            //for (Department *department in departments) {
            // Display Department details
            NSLog(@"\t\tCourse: %@, Professor: %@, ClassID: %@,%@", [class name], [class professor], [class classprefix],[class classnumber]);
            
        }
    }
}

- (void) delete
{
    // Get the context object
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // We want to delete a department
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // Want to delete the Chemistry Department
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Kyle Pineau"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    // Get the department and delete it
    StudentClass *deleteme = [fetchedObjects objectAtIndex:0];
    
    
    // Save everything
    if ([context save:&error]) {
        NSLog(@"Saved successfully!");
    } else {
        NSLog(@"Oops, save error: %@", [error localizedDescription]);
    }
}
@end
