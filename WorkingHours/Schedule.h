//
//  Schedule.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 14/08/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entity;

@interface Schedule : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * mon;
@property (nonatomic, retain) NSNumber * tue;
@property (nonatomic, retain) NSNumber * wed;
@property (nonatomic, retain) NSNumber * thu;
@property (nonatomic, retain) NSNumber * fri;
@property (nonatomic, retain) NSNumber * sat;
@property (nonatomic, retain) NSNumber * sun;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Entity *hasEntity;

-(NSString *) scheduleToString; 
@end
