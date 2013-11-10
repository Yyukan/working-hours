//
//  EntityViewController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 10/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityPeriodController.h"
#import "EntityTableHeaderController.h"
#import "CountryController.h"

#define EDIT_BUTTON_TAG 1
#define SAVE_BUTTON_TAG 2

@class Entity;
@class EntityEditableCell;
@class EntityViewableCell;

@interface EntityViewController : UITableViewController 
    <EntityPeriodControllerDelegate, CountryControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, EntityTableHeaderControllerDelegate>
{
    @private
    NSManagedObjectContext *_managedObjectContext;
    EntityTableHeaderController *_tableHeaderController;

    Entity *_entity;
    NSMutableArray *_schedules; 
    
    NSString *_street;
    NSString *_city;
    NSString *_postcode;
    NSString *_country;
    NSString *_url;
    NSString *_email;
    NSString *_phone;
    NSString *_fax;
    
    BOOL _edit;
}

@property (nonatomic, retain) Entity *entity;
@property (nonatomic, retain) NSMutableArray *schedules;

@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *postcode;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *fax;

@property (nonatomic, retain) EntityEditableCell *phoneCell;
@property (nonatomic, retain) EntityEditableCell *emailCell;
@property (nonatomic, retain) EntityEditableCell *siteCell;
@property (nonatomic, retain) EntityEditableCell *faxCell;
@property (nonatomic, retain) EntityEditableCell *streetCell;
@property (nonatomic, retain) EntityEditableCell *postCodeCell;
@property (nonatomic, retain) EntityEditableCell *countryCell;
@property (nonatomic, retain) EntityEditableCell *cityCell;

@property (nonatomic, retain) EntityViewableCell *address;

/**
 * Managed object context is for editing and saving entity
 */
@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) IBOutlet EntityEditableCell *entityEditableCell;
@property (nonatomic, assign) IBOutlet EntityViewableCell *entityViewableCell;

- (id) initWithStyle:(UITableViewStyle)style entity:(Entity *)entity;

@end
