//
//  EntityTableHeaderController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 30/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityEditableCell.h"

@protocol EntityTableHeaderControllerDelegate;

@interface EntityTableHeaderController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString *thumbnailTitle;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *note;

@property (nonatomic, assign) EntityEditableCell *nameCell;
@property (nonatomic, assign) EntityEditableCell *noteCell;

@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, assign) id <EntityTableHeaderControllerDelegate> delegate;

// special outlet to load cell from xib file
@property (nonatomic, assign) IBOutlet EntityEditableCell *entityEditableCell;

- (NSString *)nameFromTextField;
- (NSString *)noteFromTextField;

- (void)editing:(BOOL)editing;
- (void)setThumbnail:(UIImage *)image withTitle:(NSString *)title;
- (void)resetThumbnail;

- (IBAction)photoButtonTouchUpInside:(id)sender;
@end

@protocol EntityTableHeaderControllerDelegate

- (void)controller:(EntityTableHeaderController *)controller photoButtonTouchUpInside:(id)sender;

@end