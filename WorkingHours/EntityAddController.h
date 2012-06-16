//
//  EntityAddController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 03/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EntityPeriodController.h"
#import "EntityTableHeaderController.h"
#import "CountryController.h"

@class Entity;
@class EntityEditableCell;

@protocol EntityAddControllerDelegate;

@interface EntityAddController : UITableViewController 
    <EntityPeriodControllerDelegate, EntityTableHeaderControllerDelegate, CountryControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    @private 
    Entity *_entity;
    NSManagedObjectContext *_managedContext;
    
    BOOL insertAddress;
    BOOL insertDetails;    

    EntityTableHeaderController *_tableHeaderController;

    NSMutableArray *_periods; 
    NSString *_street;
    NSString *_city;
    NSString *_postcode;
    NSString *_country;
    NSString *_url;
    NSString *_email;
    NSString *_phone;
    NSString *_fax;
}
@property (nonatomic, retain) Entity *entity;
@property (nonatomic, retain) NSMutableArray *periods;

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

@property (nonatomic, retain) NSManagedObjectContext *managedContext;

@property (nonatomic, assign) id <EntityAddControllerDelegate> delegate;

//
// Outlet's declaration, is used to load custom cell from xib file
//
@property (nonatomic, assign) IBOutlet EntityEditableCell *entityEditableCell;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol EntityAddControllerDelegate
- (void)addViewController:(EntityAddController *)controller didFinishWithSave:(BOOL)save;
@end
