//
//  Schedule.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 14/08/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//

#import "Schedule.h"
#import "Entity.h"


@implementation Schedule
@dynamic start;
@dynamic end;
@dynamic active;
@dynamic note;
@dynamic date;
@dynamic mon;
@dynamic tue;
@dynamic wed;
@dynamic thu;
@dynamic fri;
@dynamic sat;
@dynamic sun;
@dynamic order;
@dynamic hasEntity;

-(NSString *) scheduleToString
{
    NSMutableString *result = [NSMutableString string];
    if (self.mon.boolValue)
    {
        [result appendString:@"Mon "];
    }
    if (self.tue.boolValue)
    {
        [result appendString:@"Tue "];
    }
    if (self.wed.boolValue)
    {
        [result appendString:@"Wed "];
    }
    if (self.thu.boolValue)
    {
        [result appendString:@"Thu "];
    }
    if (self.fri.boolValue)
    {
        [result appendString:@"Fri "];
    }
    if (self.sat.boolValue)
    {
        [result appendString:@"Sat "];
    }
    if (self.sun.boolValue)
    {
        [result appendString:@"Sun "];
    }
      
    return result;
}
@end
