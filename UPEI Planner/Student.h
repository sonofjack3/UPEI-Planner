//
//  Student.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-11.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentClass;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id picture;
@property (nonatomic, retain) NSSet *courses;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(StudentClass *)value;
- (void)removeCoursesObject:(StudentClass *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
