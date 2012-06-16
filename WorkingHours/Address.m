//
//  Address.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 06/08/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
#import "Address.h"

@implementation Address

@dynamic street;
@dynamic city;
@dynamic postCode;
@dynamic country;
@dynamic hasEntity;

- (void)addIfNotNil:(NSMutableArray *)array :(NSString *)string
{
    if (!isEmpty(string))
    {
        [array addObject:string];
    }
}

- (NSString *)addressAsString
{
    NSMutableArray *address = [NSMutableArray array];
    [self addIfNotNil:address :self.street];
    [self addIfNotNil:address :self.city];
    [self addIfNotNil:address :self.postCode];
    [self addIfNotNil:address :self.country];

    return [address componentsJoinedByString:@"\n"];
}

@end
