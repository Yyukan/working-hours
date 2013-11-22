//
//  EntityListController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 03/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "EntityAddController.h"
#import "EntityListCell.h"
#import "Entity.h"

#define TITLE_UPDATE_INTERVAL_SECONDS 60

@interface EntityListController : UIViewController <NSFetchedResultsControllerDelegate, EntityAddControllerDelegate, ADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    ADBannerView *bannerView;
}

@property (nonatomic, retain) NSTimer *titleTimer;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) IBOutlet EntityListCell *entityListCell;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)addNewEntity:(id)sender;
- (IBAction)searchEnity:(id)sender;

@end
