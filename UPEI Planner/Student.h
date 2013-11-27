//
//  Student.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-25.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//
//  Represents a student, with attributes as described in the data model

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentClass;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSNumber * id; //student's UPEI ID
@property (nonatomic, retain) NSString * name; //student's name
@property (nonatomic, retain) id picture; //profile picture
@property (nonatomic, retain) NSSet *courses; //all courses associated with this student
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(StudentClass *)value;
- (void)removeCoursesObject:(StudentClass *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
