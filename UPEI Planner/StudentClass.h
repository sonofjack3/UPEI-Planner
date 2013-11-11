//
//  StudentClass.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-11.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface StudentClass : NSManagedObject

@property (nonatomic, retain) NSNumber * classnumber;
@property (nonatomic, retain) NSString * classprefix;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * professor;
@property (nonatomic, retain) NSSet *assignment;
@property (nonatomic, retain) NSSet *exam;
@property (nonatomic, retain) NSSet *project;
@property (nonatomic, retain) NSManagedObject *student;
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
