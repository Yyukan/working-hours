//
//  Week.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 17/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import "Week.h"

@implementation Week

- (id)initWithDays:(WEEK) firstDay, ...
{
    self = [super init];
    if (self) {
        _week = [[NSMutableSet alloc] initWithCapacity:WEEK_SIZE];
        
        va_list arguments;
        va_start(arguments, firstDay); 
        WEEK day = firstDay;
        do
        {
            [self includeDay:day];
            day = va_arg(arguments, unsigned int);
        }
        while (day);
        va_end(arguments);
    }
    
    return self;
}

-(void) dealloc
{
    [_week release];
    [super dealloc];
}

-(void) includeDay:(WEEK) day
{
    [_week addObject:[NSNumber numberWithInt:day]];
}

-(void) excludeDay:(WEEK) day
{
    [_week removeObject:[NSNumber numberWithInt:day]];
}

-(BOOL) checkDay:(WEEK) day
{
    return [_week containsObject:[NSNumber numberWithInt:day]];
}

-(NSString *) schedule
{   
    // sort set 
    NSArray *array = [[_week allObjects] sortedArrayUsingSelector:@selector(compare:)];    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSNumber *day in array)
    {
        [result addObject:[Week dayShortNameByNumber:[day unsignedIntValue]]];
    }
    
    return [result componentsJoinedByString:@" "];
}

-(NSUInteger) countDay
{
    return [_week count];
}

+(Week *) defaultWeek
{
    return [[[Week alloc] initWithDays:MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, nil] autorelease];
}

+(NSString *) dayLongNameByNumber:(NSUInteger) day
{
    switch (day) {
        case MONDAY:
            return @"Monday";
        case TUESDAY:
            return @"Tuesday";
        case WEDNESDAY:
            return @"Wednesday";
        case THURSDAY:
            return @"Thursday";
        case FRIDAY:
            return @"Friday";
        case SATURDAY:
            return @"Saturday";
        case SUNDAY:
            return @"Sunday";
                
        default:
            return @"";
    }
}

+(NSString *) dayShortNameByNumber:(NSUInteger) day
{
    switch (day) {
        case MONDAY:
            return @"Mon";
        case TUESDAY:
            return @"Tue";
        case WEDNESDAY:
            return @"Wed";
        case THURSDAY:
            return @"Thu";
        case FRIDAY:
            return @"Fri";
        case SATURDAY:
            return @"Sat";
        case SUNDAY:
            return @"Sun";
            
        default:
            return @"";
    }
}

+ (Week *) weekFromSchedule:(Schedule *)schedule
{
    Week *week = [[[Week alloc] initWithDays:MONDAY, nil] autorelease];
    [week excludeDay:MONDAY];
    
    if (schedule.mon.boolValue)
    {
        [week includeDay:MONDAY];
    }
    if (schedule.thu.boolValue)
    {
        [week includeDay:TUESDAY];
    }
    if (schedule.wed.boolValue)
    {
        [week includeDay:WEDNESDAY];
    }
    if (schedule.thu.boolValue)
    {
        [week includeDay:THURSDAY];
    }
    if (schedule.fri.boolValue)
    {
        [week includeDay:FRIDAY];
    }
    if (schedule.sat.boolValue)
    {
        [week includeDay:SATURDAY];
    }
    if (schedule.sun.boolValue)
    {
        [week includeDay:SUNDAY];
    }
    return week;
}

@end
