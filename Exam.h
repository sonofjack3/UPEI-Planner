//
//  Exam.h
//  UPEI Planner
//
//  Created by Kyle Pineau on 2013-11-22.
//  Copyright (c) 2013 Kyle Pineau & Evan Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentClass;

@interface Exam : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * due_date;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * mark;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) StudentClass *classes;

@end
