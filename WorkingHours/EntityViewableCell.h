//
//  EntityViewableCell.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 05/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ENTITY_VIEWABLE_CELL_IDENTIFIER @"ENTITY_VIEWABLE_CELL"

@interface EntityViewableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
