//
//  EntityListController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 03/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityAddController.h"
#import "EntityListCell.h"
#import "Entity.h"

#define TITLE_UPDATE_INTERVAL_SECONDS 60

@interface EntityListController : UITableViewController <NSFetchedResultsControllerDelegate, EntityAddControllerDelegate>

@property (nonatomic, retain) NSTimer *titleTimer;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) IBOutlet EntityListCell *entityListCell;

- (IBAction)addNewEntity:(id)sender;
- (IBAction)searchEnity:(id)sender;

@end
