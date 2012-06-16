//
//  EntityListCell.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 03/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Logger.h"
#import "EntityListCell.h"

@implementation EntityListCell

@synthesize nameLabel = _nameLabel;
@synthesize descriptionLabel =  _descriptionLabel;
@synthesize imageLabel = _imageLabel;

- (void)dealloc {
    [_nameLabel release];
    [_descriptionLabel release];
    [_imageLabel release];
    [super dealloc];
}

@end
