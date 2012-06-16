//
//  Week.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 17/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"

#define WEEK_SIZE 7

typedef enum {
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
} WEEK;

@interface Week : NSObject
{
    @private
    NSMutableSet *_week;
}

/**
 * Initializes class with days of week, the last terminal 'nil' is mandatory
 *
 *[[Week alloc] initWithDays:MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, nil]; 
 */
- (id)initWithDays:(WEEK) firstDay, ...;

/**
 * Includes day in schedule
 */
-(void) includeDay:(WEEK) day;

/**
  * Excludes day from schedule
  */
-(void) excludeDay:(WEEK) day;

 /**
  * Check if day is in schedule
  */
-(BOOL) checkDay:(WEEK) day;

/**
 * Returns string with schedule, like this "Mon-Fri,Sun"
 */
-(NSString *) schedule;

/**
 * Returns count of the left days
 */
-(NSUInteger) countDay;
/**
 * Returns day long name, line Monday, Sunday, etc
 */
+(NSString *) dayLongNameByNumber:(NSUInteger) day;

/**
 * Returns day short name, like Mon, Sun, etc
 */
+(NSString *) dayShortNameByNumber:(NSUInteger) day;

/**
 * Returns week with default schedule
 */
+ (Week *) defaultWeek;

+ (Week *) weekFromSchedule:(Schedule *)schedule;
@end
