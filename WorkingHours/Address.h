//
//  Address.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 06/08/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entity;

@interface Address : NSManagedObject {
@private
}

@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * postCode;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) Entity *hasEntity;

- (NSString *)addressAsString;

@end
