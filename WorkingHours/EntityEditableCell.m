//
//  EditableCell.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 07/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import "EntityEditableCell.h"

@implementation EntityEditableCell

@synthesize textField = _textField;

- (void)dealloc
{
    [_textField release];
    [super dealloc];
}

@end
