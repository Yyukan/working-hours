//
//  EntityAddController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 03/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
#import "Logger.h"
#import "Utils.h"
#import "Entity.h"
#import "Schedule.h"
#import "Address.h"
#import "DateUtils.h"
#import "EntityAddController.h"
#import "EntityEditableCell.h"
#import "EntityPeriodController.h"
#import "CountryController.h"
#import "ImageUtils.h"
#import <MobileCoreServices/UTCoreTypes.h>

#define TITLE_NAVIGATION_BAR @""

#define SECTION_NUMBER 3
#define SECTION_SCHEDULE 0
#define SECTION_EXCEPTION 1
#define SECTION_ADDRESS 1
#define SECTION_DETAIL 2

#define ROW_STREET 0
#define ROW_CITY 1
#define ROW_POSTCODE 2
#define ROW_COUNTRY 3

#define ROW_URL 0
#define ROW_EMAIL 1
#define ROW_PHONE 2
#define ROW_FAX 3

static NSString *ADD_SCHEDULE_CELL_IDENTIFIER = @"ADD_SCHEDULE_CELL_IDENTIFIER";
static NSString *ADD_ADDRESS_CELL_IDENTIFIER = @"ADD_ADDRESS_CELL_IDENTIFIER";
static NSString *ADD_DETAIL_CELL_IDENTIFIER = @"ADD_DETAIL_CELL_IDENTIFIER";

@implementation EntityAddController

@synthesize delegate;

@synthesize entity = _entity;
@synthesize managedContext = _managedContext;
@synthesize entityEditableCell = _entityEditableCell;

@synthesize periods = _periods,
            phone = _phone,
            fax = _fax,
            url = _url,
            email = _email,
            country = _country,
            city = _city,
            postcode = _postcode,
            street = _street;

@synthesize streetCell = _streetCell, 
            cityCell = _cityCell, 
            postCodeCell = _postCodeCell, 
            countryCell = _countryCell, 
            siteCell = _siteCell, 
            emailCell = _emailCell, 
            phoneCell = _phoneCell, 
            faxCell = _faxCell;

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        TRC_ENTRY
        _tableHeaderController = [[EntityTableHeaderController alloc] initWithNibName:@"EntityTableHeader" bundle:nil];
        _tableHeaderController.delegate = self;
        _tableHeaderController.thumbnailTitle = @"add photo";
        
        self.periods = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc 
{
    [_phone release];
    [_fax release];
    [_url release];
    [_email release];
    [_postcode release];
    [_city release];
    [_country release];
    [_street release];
    
    [_streetCell release];
    [_cityCell release];
    [_postCodeCell release];
    [_countryCell release];
    [_siteCell release];
    [_emailCell release];
    [_phoneCell release];
    [_faxCell release];
    
    [_tableHeaderController release];
    [_periods release];
    [_entity release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    TRC_ENTRY
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    TRC_ENTRY
    self.title = @"Add";
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    // navigation bar initialization
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"done"] style:UIBarButtonItemStylePlain target:self action:@selector(save:)] autorelease];
    self.navigationController.navigationBar.tintColor = GREEN_COLOR;

    self.editing = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelectionDuringEditing = YES;

    self.tableView.tableHeaderView = _tableHeaderController.view;
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    TRC_ENTRY
    
    if ([self.periods count] > 0)
    {
        // sort schedule accordng to order
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        
        NSMutableArray *sortedSchedules = [[NSMutableArray alloc] initWithArray:self.periods];
        [sortedSchedules sortUsingDescriptors:sortDescriptors];
        
        self.periods = sortedSchedules;
        
        [sortDescriptor release];
        [sortDescriptors release];
        [sortedSchedules release];
        
        [self.tableView reloadData]; 
    }
}

- (void)viewDidUnload
{
    TRC_ENTRY
    [super viewDidUnload];
    
    // save state 
    self.street = self.streetCell.textField.text;
    self.city = self.cityCell.textField.text;
    self.postcode = self.postCodeCell.textField.text;
    self.country = self.countryCell.textField.text;
    self.url = self.siteCell.textField.text;
    self.email = self.emailCell.textField.text;
    self.phone = self.phoneCell.textField.text;
    self.fax = self.faxCell.textField.text;
    
    self.streetCell = nil;
    self.cityCell = nil;
    self.postCodeCell = nil;
    self.countryCell = nil;
    self.emailCell = nil;
    self.siteCell = nil;
    self.phoneCell = nil;
    self.faxCell = nil;
}

#pragma mark - Screen orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Data table source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_NUMBER;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section)
    {
        case SECTION_SCHEDULE:
            rows = [self.periods count];
            if (self.editing) 
            {
                rows++;
            }
            break;
        case SECTION_ADDRESS:
            if (!insertAddress)
            {
                rows = 1;
            }
            else 
            {
                rows = 4;
            }
            break;
        case SECTION_DETAIL:
            if (!insertDetails)
            {
                rows = 1;
            }
            else 
            {
                rows = 4;
            }
            break;
        default:
            break;
    }
    return rows;
}

#pragma mark UITextFieldDelegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // hide keyboard whed "done" keyboard button is pressed 
    [textField resignFirstResponder];
    return YES; 
}

- (EntityEditableCell *)loadCellWithPlaceHolder:(NSString *)placeholder andText:(NSString *)text
{
    [[NSBundle mainBundle] loadNibNamed:@"EntityEditableCell" owner:self options:nil];
    EntityEditableCell *cell = _entityEditableCell;
    self.entityEditableCell = nil;
    
    [cell.textField setDelegate:self];
    [cell.textField setText:text];
    [cell.textField setTextColor:BACKGROUND_COLOR];
    [cell.textField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: BACKGROUND_COLOR}];

    [cell setBackgroundColor:BLACK_COLOR];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [Utils adjustHeadTail:cell];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSchedule:(NSIndexPath *)indexPath 
{
    NSUInteger scheduleCount = [self.periods count];
    NSInteger row = indexPath.row;
    
    if (indexPath.row < scheduleCount) {
        static NSString *cellIdentifier = @"ScheduleCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = GLOBAL_CELL_SELECTION_STYLE;
            cell.showsReorderControl = YES;
            cell.textLabel.textColor = GREEN_COLOR;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
            cell.detailTextLabel.textColor = BACKGROUND_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BLACK_COLOR;
        }
        
        Schedule *schedule = [self.periods objectAtIndex:row];

        cell.textLabel.text = [DateUtils periodAsString:schedule.start :schedule.end];
        cell.detailTextLabel.text = [schedule scheduleToString];
        
        [Utils adjustHeadTail:cell];
        
        return cell;
    } 
    return [Utils tableView:tableView cellInsert:indexPath identifier:ADD_SCHEDULE_CELL_IDENTIFIER text:@"Add schedule"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForAddress:(NSIndexPath *)indexPath 
{
    if (!insertAddress)
    {
        return [Utils tableView:tableView cellInsert:indexPath identifier:ADD_ADDRESS_CELL_IDENTIFIER text:@"Add address"];
    }

    switch (indexPath.row) {
        case ROW_STREET:
            if (!_streetCell)
            {
                self.streetCell = [self loadCellWithPlaceHolder:@"Street" andText:self.street];
            }
            return self.streetCell;
        case ROW_CITY:
            if (!_cityCell)
            {
                self.cityCell = [self loadCellWithPlaceHolder:@"City" andText:self.city];
            }
            return self.cityCell;
        case ROW_POSTCODE:
            if (!_postCodeCell)
            {
                self.postCodeCell = [self loadCellWithPlaceHolder:@"Postcode" andText:self.postcode];
            }
            return self.postCodeCell;
        case ROW_COUNTRY:
            if (!_countryCell)
            {
                self.countryCell = [self loadCellWithPlaceHolder:@"Country" andText:self.country];
                self.countryCell.selectionStyle = GLOBAL_CELL_SELECTION_STYLE;
                self.countryCell.textField.enabled = NO;
            }
            return self.countryCell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForDetail:(NSIndexPath *)indexPath 
{
    if (!insertDetails)
    {
        return [Utils tableView:tableView cellInsert:indexPath identifier:ADD_DETAIL_CELL_IDENTIFIER text:@"Add details"];
    }    

    switch (indexPath.row) {
        case ROW_EMAIL:
            if (!_emailCell)
            {
                self.emailCell = [self loadCellWithPlaceHolder:@"Email" andText:self.email];
            }
            return self.emailCell;
        case ROW_PHONE:
            if (!_phoneCell)
            {
                self.phoneCell = [self loadCellWithPlaceHolder:@"Phone" andText:self.phone];
            }
            return self.phoneCell;
        case ROW_FAX:
            if (!_faxCell)
            {
                self.faxCell = [self loadCellWithPlaceHolder:@"Fax" andText:self.fax];
            }
            return self.faxCell;
        case ROW_URL:
            if (!_siteCell)
            {
                self.siteCell = [self loadCellWithPlaceHolder:@"Url" andText:self.url];
            }
            return self.siteCell;
    }
    
    return nil;
}

/**
 * Cell for row
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    switch (indexPath.section)
    {
        case SECTION_SCHEDULE:
            return [self tableView:tableView cellForSchedule:indexPath];            
        case SECTION_ADDRESS:
            return [self tableView:tableView cellForAddress:indexPath];
        case SECTION_DETAIL:
            return [self tableView:tableView cellForDetail:indexPath];
        default:
            return nil;
    }        
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) 
    {
        case SECTION_SCHEDULE:
            return YES;
        case SECTION_ADDRESS:
            return (insertAddress) ? NO : YES;
        case SECTION_DETAIL:
            return (insertDetails) ? NO : YES;
        default:
            break;
    }
    return NO;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    // only allow editing in the schedule section
    if (indexPath.section == SECTION_SCHEDULE) {
        // if this is the last item, it's the insertion row.
        if (indexPath.row == [self.periods count]) {
            style = UITableViewCellEditingStyleInsert;
        }
        else {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    
    if (indexPath.section == SECTION_ADDRESS && !insertAddress)
    {
        style = UITableViewCellEditingStyleInsert;
    }

    if (indexPath.section == SECTION_DETAIL && !insertDetails)
    {
        style = UITableViewCellEditingStyleInsert;
    }
    
    return style;
}

- (void)addSchedule
{
    EntityPeriodController *periodController = [[EntityPeriodController alloc] initWithNibName:@"EntitySchedule" bundle:nil];
    periodController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:periodController];
    
    [self presentViewController:navigationController animated:NO completion:nil];
    
    [navigationController release];
    [periodController release];
}

- (void)editSchedule:(NSUInteger)row
{
    EntityPeriodController *periodController = [[EntityPeriodController alloc] initWithNibName:@"EntitySchedule" bundle:nil];
    periodController.schedule = [self.periods objectAtIndex:row];
    periodController.delegate = self;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:periodController];

    [self presentViewController:navigationController animated:NO completion:nil];
    
    [navigationController release];
    [periodController release];
}

- (void)addAddress:(NSIndexPath *)indexPath
{   
    insertAddress = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:YES];
}

- (void)addDetails:(NSIndexPath *)indexPath
{
    insertDetails = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:YES];
}

- (void)addCountry
{
    CountryController *controller = [[CountryController alloc] initWithStyle:UITableViewStylePlain];
    controller.delegate = self;
    
    [Utils tableViewController:self presentModal:controller];
    
    [controller release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    switch (indexPath.section) {
        case SECTION_SCHEDULE:
            if (indexPath.row == [self.periods count]) 
            {
                // add schedule with default settings
                [self addSchedule];
            }
            else
            {
                // edit current schedule
                [self editSchedule: indexPath.row]; 
            }
            break;
        case SECTION_ADDRESS:
            if (!insertAddress)
            {
                [self addAddress:indexPath];
            } 
            else 
            {
                if (indexPath.row == ROW_COUNTRY)
                {
                    [self addCountry];
                }
            }
            break;
        case SECTION_DETAIL:
            if (!insertDetails) 
            {
                [self addDetails:indexPath];
            }
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        switch (indexPath.section)
        {
            case SECTION_SCHEDULE:
                [self addSchedule];
                break;
            case SECTION_ADDRESS:
                [self addAddress:indexPath];
                break;
            case SECTION_DETAIL:
                [self addDetails:indexPath];
                break;
        }
    } 
    else if ((editingStyle == UITableViewCellEditingStyleDelete) && (indexPath.section == SECTION_SCHEDULE)) {
        Schedule *schedule = [_periods objectAtIndex:indexPath.row];
        
        [_periods removeObject:schedule];
        
        [self.managedContext deleteObject:schedule];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark -
#pragma mark Moving rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // moves are only allowed within the schedule section, last row is not allowed to move  
    if (indexPath.section == SECTION_SCHEDULE) {
         return indexPath.row != [self.periods count];
    }
    return NO;
}

- (NSIndexPath *) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *target = proposedDestinationIndexPath;
    // moves are only allowed within the schedule section
    NSUInteger proposedSection = proposedDestinationIndexPath.section;
	
    if (proposedSection < SECTION_SCHEDULE) {
        target = [NSIndexPath indexPathForRow:0 inSection:SECTION_SCHEDULE];
    } else if (proposedSection > SECTION_SCHEDULE) {
        target = [NSIndexPath indexPathForRow:([self.periods count] - 1) inSection:SECTION_SCHEDULE];
    } else {
        NSUInteger schedulesCount = [self.periods count] - 1;
        
        if (proposedDestinationIndexPath.row > schedulesCount) {
            target = [NSIndexPath indexPathForRow:schedulesCount inSection:SECTION_SCHEDULE];
        }
    }
	
    return target;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
    Schedule *schedule = [_periods objectAtIndex:fromIndexPath.row];
    [_periods removeObjectAtIndex:fromIndexPath.row];
    [_periods insertObject:schedule atIndex:toIndexPath.row];
	
	NSInteger start = fromIndexPath.row;
	if (toIndexPath.row < start) {
		start = toIndexPath.row;
	}
	NSInteger end = toIndexPath.row;
	if (fromIndexPath.row > end) {
		end = fromIndexPath.row;
	}
	for (NSInteger i = start; i <= end; i++) {
		schedule = [_periods objectAtIndex:i];
		schedule.order = [NSNumber numberWithInteger:i];
	}
}
 
-(void)periodController:(EntityPeriodController *)controller didFinishWithSave:(BOOL)done
{   
    if (done)
    {   
        Schedule *schedule = nil;
        if (controller.schedule)
        {
            // if schedule is edited
            schedule = controller.schedule;
        }
        else
        {
            // if add new schedule
            schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedContext];
            schedule.order = [NSNumber numberWithInteger:[self.periods count]];
            [self.periods addObject:schedule];
        }
        
        schedule.start = controller.start;
        schedule.end = controller.end;
        
        schedule.active = [NSNumber numberWithBool:YES];
        schedule.note = @"";
        schedule.date = nil;
        schedule.mon = [NSNumber numberWithBool:[controller.week checkDay:MONDAY]];
        schedule.tue = [NSNumber numberWithBool:[controller.week checkDay:TUESDAY]];
        schedule.wed = [NSNumber numberWithBool:[controller.week checkDay:WEDNESDAY]];
        schedule.thu = [NSNumber numberWithBool:[controller.week checkDay:THURSDAY]];
        schedule.fri = [NSNumber numberWithBool:[controller.week checkDay:FRIDAY]];
        schedule.sat = [NSNumber numberWithBool:[controller.week checkDay:SATURDAY]];
        schedule.sun = [NSNumber numberWithBool:[controller.week checkDay:SUNDAY]];
    }    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark EntityTableHeaderController delegate

- (void)controller:(EntityTableHeaderController *)controller photoButtonTouchUpInside:(id)sender
{
    if (controller.thumbnail)
    {
        [Utils showEditPhotoAction:self.tableView delegate:self];
    }
    else 
    {
        [Utils showAddPhotoAction:self.tableView delegate:self];
    }
}

#pragma mark - Image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString*)kUTTypeImage]) 
    {
        UIImage *photoTaken = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        // make thumbnail from source image
        UIImage* thumbnailImage = [ImageUtils thumbnailWithImage:photoTaken size:THUMBNAIL_SIZE];
        
        [_tableHeaderController setThumbnail:thumbnailImage withTitle:@"edit photo"]; 
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker 
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Country controller delegate

- (void)controller:(CountryController *)controller didSelectCountry:(NSString *)country
{
    self.countryCell.textField.text = country;    
    
    [controller dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex) 
    {
        case 0: // take phote button 
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
            {
                TRC_ENTRY
                NSArray *media = [UIImagePickerController
                                  availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
                
                if ([media containsObject:(NSString*)kUTTypeImage] == YES) {
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                    [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
                    
                    picker.delegate = self;
                    [self presentViewController:picker animated:NO completion:nil];
                    [picker release];
                }
            } 
        }
        break;
        case 1: // choose photo button
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:NO completion:nil];
            [imagePicker release];
        }
        break;
        case 2: // delete photo button
        {
            [_tableHeaderController resetThumbnail];
        }
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Save and cancel operations

/**
 * Button cancel is pressed
 */
- (IBAction)cancel:(id)sender 
{
	[delegate addViewController:self didFinishWithSave:NO];
}

/**
 * Button save is pressed
 */
- (IBAction)save:(id)sender 
{
    // name is required
    if (isEmpty(_tableHeaderController.nameFromTextField))
    {
        [Utils showRequiredNameAlert];
        return;
    }     
    
    // save name, note and photo
    [_entity setName:_tableHeaderController.nameFromTextField];
    [_entity setNote:_tableHeaderController.noteFromTextField];
    [_entity setThumbnail:_tableHeaderController.thumbnail];
    
    [_entity setSchedule:[NSSet setWithArray:self.periods]];
    
    // if details exists then save details
    [_entity setPhone:self.phoneCell.textField.text];
    [_entity setSite:self.siteCell.textField.text];
    [_entity setFax:self.faxCell.textField.text];
    [_entity setEmail:self.emailCell.textField.text];

    // if address exists then create address entity
    if (!isEmpty(self.cityCell.textField.text) 
        || !isEmpty(self.postCodeCell.textField.text) 
        || !isEmpty(self.streetCell.textField.text) 
        || !isEmpty(self.countryCell.textField.text))
    {
        Address *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:self.managedContext];
        [address setCity:self.cityCell.textField.text];
        [address setPostCode:self.postCodeCell.textField.text];
        [address setStreet:self.streetCell.textField.text];
        [address setCountry:self.countryCell.textField.text];
        [_entity setAddress:address];
    }
    
	[delegate addViewController:self didFinishWithSave:YES];
}


@end
