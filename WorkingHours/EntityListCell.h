//
//  EntityListCell.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 03/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ENTITY_LIST_CELL_HEIGHT 88
#define ENTITY_DESCRIPTION_LABEL @""

@interface EntityListCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *availableLabel;

@end
