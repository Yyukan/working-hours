//
//  TestDateGateway.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 21/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Date.h"

@interface TestDateGateway : NSObject <DateProtocol>
{
    @private
    int _year;
    int _month;
    int _day;
    int _hour;
    int _minute;
    int _second;
}

- (TestDateGateway*) initWithYear:(int)year andMonth:(int)month andDay:(int)day andHour:(int)hour andMinute:(int)minute andSecond:(int)second;

@end
