//
//  Entity.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 06/08/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define DEFAULT_IMAGE @"empty.png"

@class Schedule;

@interface Entity : NSManagedObject 
{
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *fax;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *site;
@property (nonatomic, retain) NSString * upperCaseFirstLetterOfName;
@property (nonatomic, retain) NSManagedObject *address;
@property (nonatomic, retain) NSSet *schedule;
@property (nonatomic, retain) UIImage* thumbnail;
@end

@interface Entity (CoreDataGeneratedAccessors)

- (void)addScheduleObject:(Schedule *)value;
- (void)removeScheduleObject:(Schedule *)value;
- (void)addSchedule:(NSSet *)values;
- (void)removeSchedule:(NSSet *)values;
- (BOOL)hasAddress;
- (BOOL)hasDetails;
- (BOOL)hasSchedule;
@end

@interface ImageToDataTransformer : NSValueTransformer 
@end
