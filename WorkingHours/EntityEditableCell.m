//
//  EditableCell.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 07/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import "EntityEditableCell.h"

@implementation EntityEditableCell

- (void)dealloc
{
    [_textField release];
    [_imageBackView release];
    [_iconView release];
    [super dealloc];
}

@end
