//
//  DateUtilsTest.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 21/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import "DateUtilsTest.h"
#import "DateUtils.h"
#import "Date.h"
#import "TestDateGateway.h"

@implementation DateUtilsTest

- (void)setUp
{
    // set up date provider singleton only once
    _date = [Date instance];
}

- (void)testCurrentDateAsTitle {
    // ----- prepare
    [_date setDate:[[[TestDateGateway alloc] initWithYear:1970 andMonth:1 andDay:1 andHour:0 andMinute:0 andSecond:1] autorelease]];

    // ----- exercise
    NSString *actual = [DateUtils currentDateForTitle];
    
    // ----- verify
    STAssertTrue([@"Thu 01 Jan" isEqual: actual], @"Date must be %@", actual);
}

- (void)assertDateBetween:(int)startHour :(int)startMinute :(int)endHour :(int)endMinute :(int)nowHour :(int)nowMinute
{
    // ----- prepare
    [_date setDate:[[[TestDateGateway alloc] initWithYear:1970 andMonth:1 andDay:1 andHour:nowHour andMinute:nowMinute andSecond:0] autorelease]];
    
    NSDate *start = [DateUtilsTest buildWithYear:1970 andMonth:1 andDay:1 andHour:startHour andMinute:startMinute andSecond:0];
    NSDate *end = [DateUtilsTest buildWithYear:1970 andMonth:1 andDay:1 andHour:endHour andMinute:endMinute andSecond:0];

    // ----- verify
    STAssertTrue([DateUtils currentTimeAfter:start andBefore:end], @"%i:%i", nowHour, nowMinute);
}

- (void)testCurrentDateAfterAndBefore
{
    // 10:00 11:00 12:00
    [self assertDateBetween:10 :0 :12 :0 :11 :00];
    // 10:00 10:15 10:30
    [self assertDateBetween:10 :0 :10 :30 :10 :15];
    // 10:15 11:05 12:00
    [self assertDateBetween:10 :15 :12 :0 :11 :5];
    // 23:00 00:00 01:00
    [self assertDateBetween:23 :00 :1 :0 :0 :0];
    // 23:00 23:00 23:00
    [self assertDateBetween:23 :00 :23 :0 :23 :0];
    // 23:01 23:01 0:00
    [self assertDateBetween:23 :01 :0 :0 :23 :1];
    // 23:01 23:59 0:00
    [self assertDateBetween:23 :01 :0 :0 :23 :59];
}


+ (NSDate*)buildWithYear:(int)year andMonth:(int)month andDay:(int)day andHour:(int)hour andMinute:(int)minute andSecond:(int)second
{
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    return [calendar dateFromComponents:components];
}

@end

