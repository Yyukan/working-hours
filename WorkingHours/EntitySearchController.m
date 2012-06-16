//
//  EntitySearchController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 09/10/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
#import "Logger.h"
#import "DateUtils.h"
#import "ImageUtils.h"

#import "EntitySearchController.h"
#import "EntityViewController.h"
#import "EntityListCell.h"
#import "Schedule.h"

@implementation EntitySearchController

@synthesize managedObjectContext;
@synthesize entityListCell = _entityListCell;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)dealloc
{
    [_fetchedResultsController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    TRC_ENTRY
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    TRC_ENTRY
    [super viewDidLoad];

    [self.tableView setRowHeight:ENTITY_LIST_CELL_HEIGHT];
    
    [self.searchDisplayController setActive:YES];
    [self.searchDisplayController.searchBar becomeFirstResponder];
    
    [ImageUtils setBackgroundImage:self.searchDisplayController.searchResultsTableView];
    [ImageUtils setSeparatorColor:self.searchDisplayController.searchResultsTableView];
}

- (void)viewDidUnload
{
    TRC_ENTRY
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    TRC_ENTRY
    [super viewWillAppear:animated];
    // set cancel button in the search bar to black color
    [self.searchDisplayController.searchBar setTintColor:[ImageUtils tintColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    TRC_ENTRY
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    TRC_ENTRY
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    TRC_ENTRY
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Search display delegate

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setRowHeight:ENTITY_LIST_CELL_HEIGHT];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.fetchedResultsController.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", searchString]];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error during searching %@, %@ for query [%@]", error, [error userInfo], searchString);
        exit(EXIT_FAILURE); 
    }  
    
    TRC_DBG(@"Fetched [%i] entities for query [%@]", self.fetchedResultsController.fetchedObjects.count, searchString);
    return YES;
}

#pragma mark - Table view data source

- (NSFetchedResultsController *)fetchedResultsController 
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
	// fetch request for Entity
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// sort by name
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *fetchedResultsController = 
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                            managedObjectContext:managedObjectContext 
                                              sectionNameKeyPath:@"upperCaseFirstLetterOfName" 
                                                       cacheName:nil];
	
    self.fetchedResultsController = fetchedResultsController;
	_fetchedResultsController.delegate = self;
	
	[fetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[sortDescriptors release];
	
	return _fetchedResultsController;
}    

/**
 * Returns true if table view represents search table view
 */
- (BOOL)isTableViewSearch:(UITableView *)tableView
{
    return tableView == self.searchDisplayController.searchResultsTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ENTITY_LIST_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self isTableViewSearch:tableView] ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self isTableViewSearch:tableView] ? self.fetchedResultsController.fetchedObjects.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isTableViewSearch:tableView])
    {
        static NSString *CellIdentifier = @"EntityListCell";
        
        EntityListCell *cell = (EntityListCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = _entityListCell;
            self.entityListCell = nil;
        }
        
        // configure the cell
        Entity *entity = (Entity *)[_fetchedResultsController objectAtIndexPath:indexPath];
        cell.nameLabel.text = entity.name;
        cell.descriptionLabel.text = ENTITY_DESCRIPTION_LABEL;
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
                        NSString *start = [DateUtils formatTimeTo24Hours:schedule.start];
                        NSString *end = [DateUtils formatTimeTo24Hours:schedule.end];
                        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@-%@", start, end];
                        break;
                    } 
                }    
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
        
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get entity for current row
    Entity *entity = (Entity *)[_fetchedResultsController objectAtIndexPath:indexPath];
    // create a detail view controller
	EntityViewController *entityViewController = [[EntityViewController alloc] initWithStyle:UITableViewStyleGrouped entity:entity];
    // pass managed object context as entity could be removed or edited
    entityViewController.managedObjectContext = managedObjectContext;
    // push detail view controller
	[self.navigationController pushViewController:entityViewController animated:YES];
    [self.navigationController.navigationBar setTintColor:[ImageUtils tintColor]];
    
	[entityViewController release];
}

#pragma mark Fetch result controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    TRC_DBG(@"Before update [%i] entites", controller.fetchedObjects.count);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    
    TRC_DBG(@"After update [%i] entities", controller.fetchedObjects.count);
    [self.searchDisplayController.searchResultsTableView reloadData];
}


@end
