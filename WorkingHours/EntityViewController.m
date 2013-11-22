//
//  EntityViewController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 10/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
#import "Logger.h"
#import "Utils.h"
#import "DateUtils.h"

#import "Entity.h"
#import "Schedule.h"
#import "Address.h"
#import "EntityViewController.h"
#import "EntityPeriodController.h"
#import "EntityEditableCell.h"
#import "EntityViewableCell.h"
#import "EntityLocationController.h"
#import "CountryController.h"
#import "SiteController.h"
#import "ImageUtils.h"

#import <MobileCoreServices/UTCoreTypes.h>

#define SECTION_NUMBER_EDIT_MODE 4
#define SECTION_NUMBER_VIEW_MODE 6

#define SECTION_SCHEDULE 0
#define SECTION_ADDRESS 1
#define SECTION_DETAILS 2
#define SECTION_DELETE 3

#define SECTION_DETAILS_NOTE 2
#define SECTION_DETAILS_SITE 3
#define SECTION_DETAILS_EMAIL 4
#define SECTION_DETAILS_PHONE 5
#define SECTION_DETAILS_FAX 6

#define ROW_STREET 0
#define ROW_CITY 1
#define ROW_POSTCODE 2
#define ROW_COUNTRY 3

#define ROW_NOTE 0
#define ROW_URL 1
#define ROW_EMAIL 2
#define ROW_PHONE 3
#define ROW_FAX 4

#define CELL_HEIGHT 44.0

#define HEIGHT_FOR_HEADER_AND_FOOTER 20

@implementation EntityViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize entityEditableCell = _entityEditableCell;
@synthesize entityViewableCell = _entityViewableCell;
@synthesize address = _address;

@synthesize entity = _entity;
@synthesize schedules = _schedules;

@synthesize phone = _phone,
            fax = _fax,
            url = _url,
            email = _email,
            country = _country,
            city = _city,
            postcode = _postcode,
            note = _note,
            street = _street;

@synthesize streetCell = _streetCell, 
            cityCell = _cityCell, 
            postCodeCell = _postCodeCell, 
            countryCell = _countryCell, 
            siteCell = _siteCell, 
            emailCell = _emailCell, 
            phoneCell = _phoneCell,
            noteCell = _noteCell,
            faxCell = _faxCell;

- (void)initialize 
{
    [_tableHeaderController setThumbnail:_entity.thumbnail withTitle:@""];
    [_tableHeaderController setName:_entity.name];
        
    if ([_entity hasSchedule])
    {
        self.schedules = [NSMutableArray arrayWithArray:[_entity.schedule allObjects]]; 
    }
    else
    {
        self.schedules = [NSMutableArray array];
    }
    
    if ([self.entity hasAddress])
    {
        Address *address = (Address *)self.entity.address;
        self.street = address.street;
        self.city = address.city;
        self.postcode = address.postCode;
        self.country = address.country;
    }
    
    self.email = _entity.email;
    self.phone = _entity.phone;
    self.fax = _entity.fax;
    self.url = _entity.site;
    self.note = _entity.note;
}

- (id) initWithStyle:(UITableViewStyle)style entity:(Entity *)entity
{
    self = [super initWithStyle:style];
    if (self)
    {
        _edit = false;
        
        self.entity = entity;
        
        _tableHeaderController = [[EntityTableHeaderController alloc] initWithNibName:@"EntityTableHeader" bundle:nil];
        _tableHeaderController.delegate = self;
        
        [self initialize];
        
        [self setEditing:NO animated:NO];
    }    
    return self;
}

- (void)dealloc 
{
    [_note release];
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
    [_noteCell release];

    [_address release];
    [_tableHeaderController release];
    [_schedules release];
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
    self.title = [DateUtils currentDateForTitle];
    // navigation bar initialization
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonAction:)] autorelease];
    self.navigationItem.rightBarButtonItem.tag = EDIT_BUTTON_TAG;
    self.navigationController.navigationBar.tintColor = GREEN_COLOR;
    
    if (_edit)
    {
        self.editing = YES;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelectionDuringEditing = YES;

    self.tableView.tableHeaderView = _tableHeaderController.view;
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.backgroundView.backgroundColor = BACKGROUND_COLOR;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    TRC_ENTRY

    if (self.schedules.count > 0)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        
        NSMutableArray *sortedSchedules = [[NSMutableArray alloc] initWithArray:self.schedules];
        [sortedSchedules sortUsingDescriptors:sortDescriptors];
        self.schedules = sortedSchedules;
        
        [sortDescriptor release];
        [sortDescriptors release];
        [sortedSchedules release];
        
        [self.tableView reloadData]; 
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)] autorelease];
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
    [super viewDidUnload];
    // save state 
    if (self.streetCell) self.street = self.streetCell.textField.text;
    if (self.cityCell) self.city = self.cityCell.textField.text;
    if (self.postCodeCell) self.postcode = self.postCodeCell.textField.text;
    if (self.countryCell) self.country = self.countryCell.textField.text;
    if (self.siteCell) self.url = self.siteCell.textField.text;
    if (self.emailCell) self.email = self.emailCell.textField.text;
    if (self.phoneCell) self.phone = self.phoneCell.textField.text;
    if (self.faxCell) self.fax = self.faxCell.textField.text;
    if (self.noteCell) self.note = self. noteCell.textField.text;
    
    self.streetCell = nil;
    self.cityCell = nil;
    self.postCodeCell = nil;
    self.countryCell = nil;
    self.emailCell = nil;
    self.siteCell = nil;
    self.phoneCell = nil;
    self.faxCell = nil;
    self.noteCell = nil;
    
    _edit = self.editing;
}

#pragma mark - Screen orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.editing) ? SECTION_NUMBER_EDIT_MODE : SECTION_NUMBER_VIEW_MODE;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (self.editing)
    {
        switch (section)
        {
            case SECTION_SCHEDULE:
                rows = [self.schedules count];
                rows++;
                break;
            case SECTION_ADDRESS:
                rows = 4;
                break;
            case SECTION_DETAILS:
                rows = 5;
                break;
            case SECTION_DELETE:
                rows = 1;
                break;
        }
    }
    else 
    {
        switch (section)
        {
            case SECTION_SCHEDULE:
                if ([_entity hasSchedule])
                {
                    rows = [_entity.schedule count];
                } 
                break;
            case SECTION_ADDRESS:
                if ([_entity hasAddress]) {
                    rows = 1;
                }
                break;
            case SECTION_DETAILS_NOTE:
                if (!isEmpty(_entity.note)) {
                    rows = 1;
                }
                break;
            case SECTION_DETAILS_SITE:
                if (!isEmpty(_entity.site)) {
                    rows = 1;
                }
                break;
            case SECTION_DETAILS_EMAIL:
                if (!isEmpty(_entity.email)) {
                    rows = 1;
                }
                break;
            case SECTION_DETAILS_PHONE:
                if (!isEmpty(_entity.phone)) {
                    rows = 1;
                }
                break;
            case SECTION_DETAILS_FAX:
                if (!isEmpty(_entity.fax)) {
                    rows = 1;
                }
                break;
        }
    
    }
    return rows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.editing)
    {
        if (indexPath.section == SECTION_ADDRESS)
        {
            CGFloat size = 23;
            if (_entity.hasAddress)
            {
                Address *address = (Address *)_entity.address;
                if (!isEmpty(address.street)) { size += 21.0; }
                if (!isEmpty(address.city)) { size += 21.0; }
                if (!isEmpty(address.postCode)) { size += 21.0; }
                if (!isEmpty(address.country)) { size += 21.0; }
            }
            return size;
        }
    }    
    return CELL_HEIGHT;    
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
    [cell setBackgroundColor:BLACK_COLOR];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: BACKGROUND_COLOR}];
    [Utils adjustHeadTail:cell];

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSchedule:(NSIndexPath *)indexPath
{
    NSUInteger scheduleCount = [_entity.schedule count];
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row < scheduleCount) {
        static NSString *cellIdentifier = @"ScheduleCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        Schedule *schedule = [self.schedules objectAtIndex:row];
        
        cell.textLabel.text = [DateUtils periodAsString:schedule.start :schedule.end];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
        cell.textLabel.textColor = GREEN_COLOR;
        
        cell.detailTextLabel.text = [schedule scheduleToString];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        cell.detailTextLabel.textColor = BACKGROUND_COLOR;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BLACK_COLOR;
        
        [Utils adjustHeadTail:cell];
        
        if (self.editing)
        {
            cell.selectionStyle = GLOBAL_CELL_SELECTION_STYLE;
            cell.showsReorderControl = YES;
        }
        return cell;
    } 
    
    return [Utils tableView:tableView cellInsert:indexPath identifier:@"AddScheduleCell" text:@"Add schedule"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForDelete:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DeleteCell";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        
        cell.selected = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // draw delete button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:[cell.contentView frame]];
        [button setTitle:@"Delete" forState:UIControlStateNormal];
        [button setTitleColor:RED_COLOR forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteEntity:) forControlEvents:UIControlEventTouchUpInside];
        [button setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight]; 
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:[Utils emptyView]];
        
        [cell addSubview:button]; 
    }

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForAddressSingle:(NSIndexPath *)indexPath
{
    if (!_address)
    {
        [[NSBundle mainBundle] loadNibNamed:@"EntityViewableCell" owner:self options:nil];
        self.address = _entityViewableCell;
        self.entityViewableCell = nil;
        self.address.textView.scrollEnabled = NO;
        self.address.selected = YES;
        self.address.selectionStyle = GLOBAL_CELL_SELECTION_STYLE;
    }
        
    if ([self.entity hasAddress])
    {
        Address *address = (Address *)self.entity.address;
            
        self.address.textView.text = [address addressAsString];
    }
    [Utils adjustHeadTail:self.address height:[self tableView:self.tableView heightForRowAtIndexPath:indexPath]];

    return self.address;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForAddress:(NSIndexPath *)indexPath 
{
    
    switch (indexPath.row) 
    {
        case ROW_STREET:
            if (!_streetCell)
            {
                self.streetCell = [self loadCellWithPlaceHolder:@"street" andText:self.street];
            }
            return self.streetCell;
        case ROW_CITY:
            if (!_cityCell)
            {
                self.cityCell = [self loadCellWithPlaceHolder:@"city" andText:self.city];
            }
            return self.cityCell;
        case ROW_POSTCODE:
            if (!_postCodeCell)
            {
                self.postCodeCell = [self loadCellWithPlaceHolder:@"postcode" andText:self.postcode];
            }
            return self.postCodeCell;
        case ROW_COUNTRY:
            if (!_countryCell)
            {
                self.countryCell = [self loadCellWithPlaceHolder:@"country" andText:self.country];
                self.countryCell.selectionStyle = GLOBAL_CELL_SELECTION_STYLE;
                self.countryCell.textField.enabled = NO;
            }
            return self.countryCell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForDetail:(NSIndexPath *)indexPath 
{
    switch (indexPath.row) {
        case ROW_NOTE:
            if (!_noteCell)
            {
                self.noteCell = [self loadCellWithPlaceHolder:@"note" andText:self.note];
            }
            [self.noteCell.textField setEnabled:YES];
            return self.noteCell;
        case ROW_EMAIL:
            if (!_emailCell)
            {
                self.emailCell = [self loadCellWithPlaceHolder:@"email" andText:self.email];
            }
            [self.emailCell.textField setEnabled:YES];
            return self.emailCell;
        case ROW_PHONE:
            if (!_phoneCell)
            {
                self.phoneCell = [self loadCellWithPlaceHolder:@"phone" andText:self.phone];
            }
            [self.phoneCell.textField setEnabled:YES];
            return self.phoneCell;
        case ROW_FAX:
            if (!_faxCell)
            {
                self.faxCell = [self loadCellWithPlaceHolder:@"fax" andText:self.fax];
            }
            [self.faxCell.textField setEnabled:YES];
            return self.faxCell;
        case ROW_URL:
            if (!_siteCell)
            {
                self.siteCell = [self loadCellWithPlaceHolder:@"url" andText:self.url];
            }
            [self.siteCell.textField setEnabled:YES];
            return self.siteCell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (self.editing)
    {
        switch (indexPath.section)
        {
            case SECTION_SCHEDULE:
                return [self tableView:tableView cellForSchedule:indexPath];            
                
            case SECTION_ADDRESS:
                return [self tableView:tableView cellForAddress:indexPath];

            case SECTION_DETAILS:
                return [self tableView:tableView cellForDetail:indexPath];
    
            case SECTION_DELETE:
                return [self tableView:tableView cellForDelete:indexPath];    
        }
    } 
    else 
    {
        switch (indexPath.section)
        {
            case SECTION_SCHEDULE:
                return [self tableView:tableView cellForSchedule:indexPath];            
                
            case SECTION_ADDRESS:
                return [self tableView:tableView cellForAddressSingle:indexPath];
             
            case SECTION_DETAILS_NOTE:
                if (!_noteCell)
                {
                    self.noteCell = [self loadCellWithPlaceHolder:@"note" andText:self.note];
                }
                [self.noteCell.textField setEnabled:NO];
                return self.noteCell;
            case SECTION_DETAILS_SITE:
                if (!_siteCell)
                {
                    self.siteCell = [self loadCellWithPlaceHolder:@"url" andText:self.url];
                }
                [self.siteCell.textField setEnabled:NO];
                return self.siteCell;
            case SECTION_DETAILS_EMAIL:
                if (!_emailCell)
                {
                    self.emailCell = [self loadCellWithPlaceHolder:@"email" andText:self.email];
                }
                [self.emailCell.textField setEnabled:NO];
                return self.emailCell;
            case SECTION_DETAILS_PHONE:
                if (!_phoneCell)
                {
                    self.phoneCell = [self loadCellWithPlaceHolder:@"phone" andText:self.phone];
                }
                [self.phoneCell.textField setEnabled:NO];
                return self.phoneCell;
            case SECTION_DETAILS_FAX:
                if (!_faxCell)
                {
                    self.faxCell = [self loadCellWithPlaceHolder:@"fax" andText:self.fax];
                }
                [self.faxCell.textField setEnabled:NO];
                return self.faxCell;
        } 
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
    if (section == 0)
    {
        return HEIGHT_FOR_HEADER_AND_FOOTER - 10;
    }
    
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) 
    {
        return 0;
    }
    else   
    {
        return HEIGHT_FOR_HEADER_AND_FOOTER;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section 
{
    if (section == [self numberOfSectionsInTableView:tableView] - 1) 
    {
        return HEIGHT_FOR_HEADER_AND_FOOTER;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Schedule";
}

- (UIView *)sectionFiller {
    static UILabel *emptyLabel = nil;
    if (!emptyLabel) {
        emptyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        emptyLabel.backgroundColor = [UIColor clearColor];
    }
    return emptyLabel;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self sectionFiller];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self sectionFiller];
}

#pragma mark -
#pragma mark Editing

- (BOOL) save
{
    if (isEmpty(_tableHeaderController.nameFromTextField))
    {    
        [Utils showRequiredNameAlert];
        return FALSE;
    }
    
    [self.entity setName:_tableHeaderController.nameFromTextField];
    [self.entity setThumbnail:_tableHeaderController.thumbnail];
    
    if (self.noteCell) [self.entity setNote:self.noteCell.textField.text];
    if (self.siteCell) [self.entity setSite:self.siteCell.textField.text];
    if (self.emailCell) [self.entity setEmail:self.emailCell.textField.text];
    if (self.phoneCell) [self.entity setPhone:self.phoneCell.textField.text];
    if (self.faxCell) [self.entity setFax:self.faxCell.textField.text];
    
    Address *address;
    if ([self.entity hasAddress])
    {
        address = (Address *)self.entity.address;
    } 
    else
    {
        address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:self.managedObjectContext];
        [self.entity setAddress:address];
    }

    if (self.streetCell) [address setStreet:self.streetCell.textField.text];
    if (self.cityCell) [address setCity:self.cityCell.textField.text];
    if (self.postCodeCell) [address setPostCode:self.postCodeCell.textField.text];
    if (self.countryCell) [address setCountry:self.countryCell.textField.text];

    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Unresolved error while saving %@, %@", error, [error userInfo]);
        exit(EXIT_FAILURE);
    }

    return TRUE;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
    TRC_ENTRY
    [super setEditing:editing animated:animated];

    [_tableHeaderController editing:editing];
    if (editing) 
    {
        // add cancel button
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
        [self.tableView reloadData];
    } 
    else 
    {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)] autorelease];

        [self.tableView reloadData];
    }
}

- (IBAction)back:(id)sender {
    TRC_ENTRY
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender 
{
    // restore all values 
    [self initialize];
    
    [self setEditing:NO animated:YES];
    
    self.streetCell = nil;
    self.cityCell = nil;
    self.postCodeCell = nil;
    self.countryCell = nil;
    self.emailCell = nil;
    self.siteCell = nil;
    self.phoneCell = nil;
    self.faxCell = nil;
    self.noteCell = nil;
    
    [self.tableView reloadData];
}


-(IBAction)editButtonAction:(id)sender
{
    TRC_ENTRY
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    if (button.tag == EDIT_BUTTON_TAG)
    {
        [self setEditing:YES animated:YES];
    } 
    else if (button.tag == SAVE_BUTTON_TAG)
    {
        if ([self save])
        {
            [self setEditing:NO animated:YES];
        }    
    }    
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    // only allow editing in the schedule section
    if (indexPath.section == SECTION_SCHEDULE) {
        // if this is the last item, it's the insertion row.
        if (indexPath.row == [self.entity.schedule count]) {
            style = UITableViewCellEditingStyleInsert;
        }
        else {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    
    return style;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SECTION_SCHEDULE:
            return YES;
        default:
            break;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES; 
}

- (void)addSchedule
{
    if ([self save])
    {
        EntityPeriodController *periodController = [[EntityPeriodController alloc] initWithNibName:@"EntitySchedule" bundle:nil];
        periodController.delegate = self;
        
        [Utils tableViewController:self presentModal:periodController];
        
        [periodController release];    
    }    
}

- (void)editSchedule:(NSUInteger)row
{
    if ([self save])
    {    
        EntityPeriodController *periodController = [[EntityPeriodController alloc] initWithNibName:@"EntitySchedule" bundle:nil];
        periodController.schedule = [_schedules objectAtIndex:row];
        periodController.delegate = self;
        
        [Utils tableViewController:self presentModal:periodController];
        
        [periodController release];    
    }    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // insert new schedule
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        switch (indexPath.section)
        {
            case SECTION_SCHEDULE:
                [self addSchedule];
                break;
        }
    } 
    // delete schedule
    else if ((editingStyle == UITableViewCellEditingStyleDelete) && (indexPath.section == SECTION_SCHEDULE)) {
        Schedule *schedule = [_schedules objectAtIndex:indexPath.row];
        
        [_entity removeScheduleObject:schedule];
        [_schedules removeObject:schedule];
        
        [_managedObjectContext deleteObject:schedule];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)showLocation
{
    EntityLocationController *controller = [[EntityLocationController alloc] init];
    controller.entity = self.entity;
    controller.navigationItem.title = self.entity.name;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];    
}

- (void)showSite:(NSString *)url
{
    if (!isEmpty(url))
    {
        SiteController *controller = [[SiteController alloc] init];   
        controller.url = url;
        controller.navigationItem.title = self.entity.name;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        [controller release];    
    }
}

- (void)sendEmail:(NSString *)email
{
    if (!isEmpty(email))
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto://" stringByAppendingString:email]]];
    }
}

- (void)callPhone:(NSString *)phone
{
    if (!isEmpty(phone))
    {
        NSString *number = [phone  stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
        number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
        number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
        number = [number stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        TRC_DBG(@"Calling phone [%@]", number);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:number]]];
    }
}

- (void)addCountry
{
    CountryController *controller = [[CountryController alloc] initWithStyle:UITableViewStylePlain];
    controller.delegate = self;

    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    switch (indexPath.section) 
    {
        case SECTION_SCHEDULE:
            if (self.editing) 
            {
                if (indexPath.row == [_entity.schedule count]) 
                {
                    // add schedule with default settings
                    [self addSchedule];
                }
                else 
                {
                    // edit current schedule
                    [self editSchedule: indexPath.row]; 
                }
            }    
            break;
        case SECTION_ADDRESS:
            if (!self.editing)
            {
                [self showLocation];
            }
            else 
            {
                if (indexPath.row == ROW_COUNTRY)
                {
                    [self addCountry];
                }
                break;
            }
            break;
        case SECTION_DETAILS_SITE:
            if (!self.editing)
            {
                [self showSite:self.entity.site];
            }
            break;
        case SECTION_DETAILS_EMAIL:
            if (!self.editing)
            {
                [self sendEmail:self.entity.email];
            }
            break;
        case SECTION_DETAILS_PHONE:
            if (!self.editing)
            {
                [self callPhone:self.entity.phone];
            }
            break;
        case SECTION_DETAILS_FAX:
            if (!self.editing)
            {
                [self callPhone:self.entity.fax];
            }
            break;
        default:
            break;
    }
}


- (IBAction)deleteEntity:(id)sender
{
    [Utils showOKCancelAction:self.view withOkTitle:@"Delete" delegate:self];
}

#pragma mark -
#pragma mark Moving rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // moves are only allowed within the schedule section, last row is not allowed to move  
    if (indexPath.section == SECTION_SCHEDULE) {
        return indexPath.row != [_entity.schedule count];
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
        target = [NSIndexPath indexPathForRow:([_entity.schedule count] - 1) inSection:SECTION_SCHEDULE];
    } else {
        NSUInteger ingredientsCount_1 = [_entity.schedule count] - 1;
        
        if (proposedDestinationIndexPath.row > ingredientsCount_1) {
            target = [NSIndexPath indexPathForRow:ingredientsCount_1 inSection:SECTION_SCHEDULE];
        }
    }
	
    return target;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
    Schedule *schedule = [_schedules objectAtIndex:fromIndexPath.row];
    [_schedules removeObjectAtIndex:fromIndexPath.row];
    [_schedules insertObject:schedule atIndex:toIndexPath.row];
	
	NSInteger start = fromIndexPath.row;
	if (toIndexPath.row < start) {
		start = toIndexPath.row;
	}
	NSInteger end = toIndexPath.row;
	if (fromIndexPath.row > end) {
		end = fromIndexPath.row;
	}
	for (NSInteger i = start; i <= end; i++) {
		schedule = [_schedules objectAtIndex:i];
		schedule.order = [NSNumber numberWithInteger:i];
	}
}

- (void)periodController:(EntityPeriodController *)controller didFinishWithSave:(BOOL)done
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
            schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:self.managedObjectContext];
            schedule.order = [NSNumber numberWithInteger:[_entity.schedule count]];
            
            [self.schedules addObject:schedule];
            [_entity addScheduleObject:schedule];
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
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedEditButtonAtIndex:(NSInteger)buttonIndex;
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
#pragma mark Delete

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet.tag == SHOW_OK_CANCEL_ACTION)
    {
        switch (buttonIndex) {
            case 0: // delete button has been pressed
                [_managedObjectContext deleteObject:_entity];
                
                // Save the context.
                NSError *error;
                if (![_managedObjectContext save:&error]) 
                {
                    NSLog(@"Unresolved error during deleting %@, %@", error, [error userInfo]);
                    exit(EXIT_FAILURE);
                }
                [self.navigationController popViewControllerAnimated:YES]; 
                
                break;
            case 1: // cancel button, do nothing
                break;
                
            default:
                break;
        }
    } 
    else 
    {
        [self actionSheet:actionSheet clickedEditButtonAtIndex:buttonIndex];
    }
}

#pragma mark -
#pragma mark EntityTableHeaderController delegate

- (void)controller:(EntityTableHeaderController *)controller photoButtonTouchUpInside:(id)sender
{
    if (self.editing)
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
}

#pragma mark - Image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo 
{
    // make thumbnail from source image
    UIImage* thumbnailImage = [ImageUtils thumbnailWithImage:selectedImage];

    [_tableHeaderController setThumbnail:thumbnailImage withTitle:@"edit photo"]; 

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

    [self.navigationController popViewControllerAnimated:YES];
}    

@end


