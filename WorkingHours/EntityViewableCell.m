//
//  EntityViewableCell.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 05/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import "EntityViewableCell.h"

@implementation EntityViewableCell

@synthesize textView = _textView;

- (void)dealloc
{
    [_textView release];
    [super dealloc];
}

@end
