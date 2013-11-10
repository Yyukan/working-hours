//
//  EditableCell.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 07/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ENTITY_EDITABLE_CELL_IDENTIFIER @"ENTITY_EDITABLE_CELL"

@interface EntityEditableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIImageView *imageBackView;
@property (nonatomic, retain) IBOutlet UIImageView *iconView;

@end
