//
//  Entity.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 06/08/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//

#import "Entity.h"
#import "Address.h"
#import "Common.h"

@implementation Entity

@dynamic name;
@dynamic image;
@dynamic note;
@dynamic phone;
@dynamic fax;
@dynamic email;
@dynamic site;
@dynamic address;
@dynamic upperCaseFirstLetterOfName;
@dynamic schedule;
@dynamic thumbnail;

- (NSString *)upperCaseFirstLetterOfName
{
    [self willAccessValueForKey:@"upperCaseFirstLetterOfName"];
    NSString *tmp = [[self valueForKey:@"name"] uppercaseString];
    
    // support UTF-16:
    NSString *result = [tmp substringWithRange:[tmp rangeOfComposedCharacterSequenceAtIndex:0]];
    
    [self didAccessValueForKey:@"upperCaseFirstLetterOfName"];
    return result;
}

- (BOOL)hasSchedule
{
    return !isEmpty(self.schedule);
}

- (BOOL)hasAddress
{
    Address *address = (Address *)self.address;
    if (address != nil)
    {
        return !isEmpty(address.city) || !isEmpty(address.street) || !isEmpty(address.postCode) || !isEmpty(address.country);
    }
    return NO;
}

- (BOOL) hasDetails
{
    return !isEmpty(self.site) || !isEmpty(self.phone) || !isEmpty(self.fax) || !isEmpty(self.email);
}

@end

@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation 
{
	return YES;
}

+ (Class)transformedValueClass 
{
	return [NSData class];
}

- (id)transformedValue:(id)value 
{
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value 
{
	return [[[UIImage alloc] initWithData:value] autorelease];
}

@end