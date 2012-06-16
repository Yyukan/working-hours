//
//  DateUtilsTest.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 21/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

@class Date;

@interface DateUtilsTest : SenTestCase
{
    Date *_date;
}

+ (NSDate*)buildWithYear:(int)year andMonth:(int)month andDay:(int)day andHour:(int)hour andMinute:(int)minute andSecond:(int)second;
@end
