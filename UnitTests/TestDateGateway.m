//
//  TestDateGateway.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 21/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import "TestDateGateway.h"

@implementation TestDateGateway

- (TestDateGateway*) initWithYear:(int)year andMonth:(int)month andDay:(int)day andHour:(int)hour andMinute:(int)minute andSecond:(int)second
{
    self = [super init];
    
    if (self)
    { 
        _year = year;
        _month = month;
        _day = day;
        _hour = hour;
        _minute = minute;
        _second = second;
    }
    return self;
}

- (NSDate *)now
{
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    components.year = _year;
    components.month = _month;
    components.day = _day;
    components.hour = _hour;
    components.minute = _minute;
    components.second = _second;
    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    return [calendar dateFromComponents:components];
}

@end
