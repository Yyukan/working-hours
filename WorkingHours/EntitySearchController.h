//
//  EntitySearchController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 09/10/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity.h"

@class EntityListCell;

@interface EntitySearchController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, assign) IBOutlet EntityListCell *entityListCell;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;

@end
