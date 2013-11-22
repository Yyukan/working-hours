//
//  EntityListController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 03/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
#import "Logger.h"
#import "Utils.h"
#import "DateUtils.h"
#import "ImageUtils.h"

#import "EntityListController.h"
#import "EntityListCell.h"
#import "EntityAddController.h"
#import "EntityViewController.h"
#import "EntitySearchController.h"
#import "Schedule.h"

@interface EntityListController()
{
    BOOL _bannerVisible;
}
@end

@implementation EntityListController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize entityListCell = _entityListCell;
@synthesize titleTimer = _titleTimer;

#pragma mark - Memory lifecycle

- (void)dealloc
{
    [_titleTimer release];
    [_fetchedResultsController release];
    [_managedObjectContext release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    TRC_ENTRY
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

/**
 * Method is called from timer to update date in the title
 */
- (void)updateDateInTitleAndReloadData
{
    // update title with current date
    self.title = [DateUtils currentDateForTitle];

    // update visible cells to update schedule
    TRC_DBG(@"Reload table data by timer");
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    TRC_ENTRY
    [super viewDidLoad];
    
    _bannerVisible = NO;
    // perform initial load of entity list
    if (!_fetchedResultsController)
    {
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error]) 
        {
            // Update to handle the error appropriately.
            NSLog(@"Error while initial loading of data %@, %@", error, [error userInfo]);
            exit(EXIT_FAILURE);
        }
        
        TRC_DBG(@"Fetched [%i] entities", _fetchedResultsController.fetchedObjects.count);
    }

    [self bannerViewDidLoad];
    
    // navigation bar initialization
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewEntity:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchEnity:)] autorelease];
    
    self.navigationController.navigationBar.tintColor = GREEN_COLOR;
    
    [self updateDateInTitleAndReloadData];
        
    // create scheduled timer to update date in the title
    self.titleTimer = [NSTimer scheduledTimerWithTimeInterval:TITLE_UPDATE_INTERVAL_SECONDS target:self selector:@selector(updateDateInTitleAndReloadData) userInfo:nil repeats:YES];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.sectionIndexBackgroundColor = BACKGROUND_COLOR;
    self.tableView.sectionIndexColor = GREEN_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}

- (void) bannerViewDidLoad
{
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    bannerView.delegate = self;
    
    CGRect adFrame = bannerView.frame;
    adFrame.origin.y = self.view.frame.size.height - bannerView.frame.size.height - 64;
    bannerView.frame = adFrame;
    // add banner on the screen
    [self.view addSubview:bannerView];
}


- (void) viewWillAppear:(BOOL)animated
{
    TRC_ENTRY
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    TRC_ENTRY
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    TRC_ENTRY
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    TRC_ENTRY
}

- (void)viewDidUnload
{
    TRC_ENTRY
    [_titleTimer invalidate];
    self.titleTimer = nil;
    bannerView = nil;

    [super viewDidUnload];
}

/**
 * Method supports orientation
 */ 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - Table view data source

/**
 * Returns the number of sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

/**
 * Returns the number of rows in the section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return nil;
} 

/**
 * Returns list of the section indexes which appear for quick searching
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [NSArray arrayWithObjects:
            @"A",@"B",@"C",@"D",@"E",@"F",@"H",@"I",@"J",@"K",@"L",@"N",@"P",@"Q",
            @"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", @"#", nil];
}

/**
 * Returns section index by section index title
 */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)section atIndex:(NSInteger)index
{
    NSArray *sections = [_fetchedResultsController sectionIndexTitles];
    if ([sections containsObject:section])
    {
        return [sections indexOfObject:section];
    } 
    else if ([@"#" isEqualToString:section])
    {
        // return last section position
        return [sections indexOfObject:[sections lastObject]];
    }
    return 0;
}

/**
 * Returns height for list cell (both list table and search table)
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ENTITY_LIST_CELL_HEIGHT; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntityListCell";
    
    EntityListCell *cell = (EntityListCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = _entityListCell;
        self.entityListCell = nil;
    }
    
    // Configure the cell
    Entity *entity = (Entity *)[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = [NSString stringWithFormat:@" %@", entity.name];
    cell.descriptionLabel.text = ENTITY_DESCRIPTION_LABEL;
    cell.selectionStyle = GLOBAL_CELL_SELECTION_STYLE;
    cell.backgroundView.backgroundColor = BACKGROUND_COLOR;
    cell.backgroundColor = BACKGROUND_COLOR;
    if (entity.thumbnail)
    {
        cell.imageLabel.image = entity.thumbnail;
    }
    else 
    {
        cell.imageLabel.image = [UIImage imageNamed:DEFAULT_IMAGE];
    }    

    
    if ([entity.schedule count])
    {
        for (Schedule *schedule in entity.schedule)
        {
            // check that current week day is in schedule
            if ([DateUtils currentWeekDay:schedule.mon :schedule.tue :schedule.wed :schedule.thu :schedule.fri :schedule.sat :schedule.sun])
            {    
                // check current time is in schedule
                if ([DateUtils currentTimeAfter:schedule.start andBefore:schedule.end])
                {
                    cell.descriptionLabel.text = [DateUtils periodAsString:schedule.start :schedule.end];
                    cell.descriptionLabel.textColor = GREEN_COLOR;
                    break;
                } 
            }    
        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get entity for current row
    Entity *entity = (Entity *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    // create a detail view controller
	EntityViewController *entityViewController = [[EntityViewController alloc] initWithStyle:UITableViewStyleGrouped entity:entity];
    // pass managed object context as entity could be removed or edited
    entityViewController.managedObjectContext = _managedObjectContext;
    // push detail view controller
	[self.navigationController pushViewController:entityViewController animated:YES];

	[entityViewController release];
}

#pragma mark -
#pragma mark Fetched results controller

/**
 * Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:_managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"upperCaseFirstLetterOfName" cacheName:nil];
	
    self.fetchedResultsController = fetchedResultsController;
	_fetchedResultsController.delegate = self;
	
	[fetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[sortDescriptors release];
	
	return _fetchedResultsController;
}    

- (IBAction)searchEnity:(id)sender
{
    TRC_ENTRY
    
    EntitySearchController *entitySearchController = [[EntitySearchController alloc] initWithNibName:@"EntitySearchController" bundle:nil];
    entitySearchController.managedObjectContext = self.managedObjectContext;

    [self.navigationController pushViewController:entitySearchController animated:YES];

    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entitySearchController];
//    
//    [self presentViewController:navigationController animated:NO completion:nil];
//	
    [entitySearchController release];
//    [navigationController release];
}

- (IBAction)addNewEntity:(id)sender
{
    TRC_ENTRY
    // create entity add controller
    EntityAddController *entityAddController = [[EntityAddController alloc] initWithStyle:UITableViewStyleGrouped];
    // setup delegate to responce cancel and save events
    entityAddController.delegate = self;
    entityAddController.managedContext = self.managedObjectContext;
    // create managed entity
    entityAddController.entity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entityAddController];
    
    [self presentViewController:navigationController animated:NO completion:nil];
	
    [entityAddController release];    
    [navigationController release];
}

/**
 * Delegate method is called when new entity is saved or addition has been cancelled
 */
- (void)addViewController:(EntityAddController *)controller didFinishWithSave:(BOOL)save 
{
	if (save) 
    {
        TRC_DBG(@"Objects in the list [%i]", _fetchedResultsController.fetchedObjects.count);

		NSError *error;
		if (![self.managedObjectContext save:&error]) 
        {
			NSLog(@"Error during saving new entity %@, %@", error, [error userInfo]);
			exit(-1);
		}
        TRC_DBG(@"Entity has been saved...");
    }
    else 
    {
        NSMutableArray *schedules = [controller periods];

        // delete any created schedule 
        for (Schedule *schedule in schedules)
        {
            [self.managedObjectContext deleteObject:schedule];
        }
        
        // delete created entity 
        [self.managedObjectContext deleteObject:[controller entity]];
        
        TRC_DBG(@"Entity has been declined...");
    }
    
    // Dismiss the modal view to return to the main list
    [self dismissViewControllerAnimated:NO completion:nil];
}

/**
 * Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    TRC_DBG(@"Before update [%i] entites", controller.fetchedObjects.count);

    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath 
{
	UITableView *tableView = self.tableView;

	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            TRC_DBG(@"CHANGE INSERT");
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			TRC_DBG(@"CHANGE DELETE");
            break;
			
		case NSFetchedResultsChangeUpdate:
            TRC_DBG(@"CHANGE UPDATE");
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:NO];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            TRC_DBG(@"CHANGE MOVE");
            break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
	switch(type) {
		case NSFetchedResultsChangeInsert:
            TRC_DBG(@"SECTION CHANGE INSERT")
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
            TRC_DBG(@"SECTION CHANGE DELETE")
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    [self.tableView endUpdates];
    
    TRC_DBG(@"After update [%i] entities", controller.fetchedObjects.count);
}

#pragma mark Banner 
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    TRC_ENTRY
    if (!_bannerVisible) {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame
                                            .origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - banner.frame.size.height)];
        _bannerVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    TRC_ENTRY
    if (_bannerVisible) {
        // TODO:yukan add here AD MOB ads
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame
                                            .origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + banner.frame.size.height)];
        _bannerVisible = NO;
    }
}



@end


