//
//  StudentClass.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-11.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents a Student Class, with attributes as described in the data model

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface StudentClass : NSManagedObject

@property (nonatomic, retain) NSNumber * classnumber; //course number (eg: 252)
@property (nonatomic, retain) NSString * classprefix; //course prefix (eg: CS)
@property (nonatomic, retain) NSString * name; //course name (eg: iPhone Programming)
@property (nonatomic, retain) NSString * professor; //course professor's name
@property (nonatomic, retain) NSMutableSet *assignment; //set of assignments for this course
@property (nonatomic, retain) NSMutableSet *exam; //set of exams for this course
@property (nonatomic, retain) NSMutableSet *project; //set of projects for this course
@property (nonatomic, retain) NSManagedObject *student; //Student associated with this course
@end

@interface StudentClass (CoreDataGeneratedAccessors)

- (void)addAssignmentObject:(NSManagedObject *)value;
- (void)removeAssignmentObject:(NSManagedObject *)value;
- (void)addAssignment:(NSSet *)values;
- (void)removeAssignment:(NSSet *)values;

- (void)addExamObject:(NSManagedObject *)value;
- (void)removeExamObject:(NSManagedObject *)value;
- (void)addExam:(NSSet *)values;
- (void)removeExam:(NSSet *)values;

- (void)addProjectObject:(Project *)value;
- (void)removeProjectObject:(Project *)value;
- (void)addProject:(NSSet *)values;
- (void)removeProject:(NSSet *)values;

@end
