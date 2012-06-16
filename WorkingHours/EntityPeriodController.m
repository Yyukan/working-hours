//
//  EntityPeriodController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 13/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
#import "Logger.h"
#import "ImageUtils.h"
#import "DateUtils.h"
#import "Entity.h"
#import "Schedule.h"
#import "Week.h"
#import "EntityPeriodController.h"
#import "EntityWeekDayController.h"

@implementation EntityPeriodController

@synthesize delegate;
@synthesize end = _end;
@synthesize start = _start;
@synthesize week = _week;
@synthesize schedule = _schedule;
@synthesize datePicker = _datePicker;

- (void)dealloc
{
    [_datePicker release];
    [_week release];
    [_schedule release];
    [_start release];
    [_end release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    TRC_ENTRY
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload
{
    TRC_ENTRY
    self.datePicker = nil;
    [super viewDidUnload];
}

- (UIDatePicker *)createDatePicker {
    UIDatePicker *datePicker =[[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.hidden = YES; 
    
    [datePicker addTarget:self
                   action:@selector(changeDateInLabel:)
         forControlEvents:UIControlEventValueChanged];

    
    
    return [datePicker autorelease];
}

- (void)initializeScheduleAndWeek
{
    // if schedule is set than schedule is edited not added
    if (!_schedule) 
    {
        self.start = [DateUtils dateWithHours:9 andMinutes:0]; 
        self.end = [DateUtils dateWithHours:18 andMinutes:0];
        self.week = [Week defaultWeek];
        self.title = @"";
    }
    else 
    {
        self.start = _schedule.start;
        self.end = _schedule.end;
        self.week = [Week weekFromSchedule:_schedule];
        self.title = @"";
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                   target:self action:@selector(cancel:)] autorelease];

    self.navigationItem.rightBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                   target:self action:@selector(done:)] autorelease];
    self.editing = NO;
    self.tableView.scrollEnabled = NO;
    
    [self initializeScheduleAndWeek];
    self.datePicker = [self createDatePicker];

    self.tableView.tableFooterView = self.datePicker;

    self.navigationController.navigationBar.tintColor = [ImageUtils tintColor];
    [ImageUtils setBackgroundImage:self.tableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"PeriodCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier] autorelease];
    }   
    switch (indexPath.row) {
        case START_CELL_ROW:
            cell.textLabel.text = @"start";
            cell.detailTextLabel.text = [DateUtils formatTimeTo24Hours:self.start];
            break;
        case END_CELL_ROW:
            cell.textLabel.text = @"end";
            cell.detailTextLabel.text = [DateUtils formatTimeTo24Hours:self.end];
            break;
        case DAY_CELL_ROW:
            cell.textLabel.text = @"day";
            cell.detailTextLabel.text = [_week schedule];
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [ImageUtils cellBackGround];
    
    return cell;
}

-(void)showModalWeekOfDayView
{
    EntityWeekDayController *weekDayController = [[EntityWeekDayController alloc] initWithStyle:UITableViewStyleGrouped];
    weekDayController.delegate = self;
    weekDayController.week = self.week;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:weekDayController];
	navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    [self.navigationController presentModalViewController:navigationController animated:YES];
	
    [weekDayController release];    
    [navigationController release];
}

-(void)showTimePicker:(NSDate *)date withTag:(NSInteger) tag;
{
    self.datePicker.date = [date.copy autorelease];
    self.datePicker.tag = tag;
    self.datePicker.hidden = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case START_CELL_ROW:
            [self showTimePicker:self.start withTag:START_CELL_ROW];
            break;
        case END_CELL_ROW:
            [self showTimePicker:self.end withTag:END_CELL_ROW];
            break;
        case DAY_CELL_ROW:
            [self.datePicker setHidden:YES];
            [self showModalWeekOfDayView];
            break;
    }    
}

- (void)changeDateInLabel:(id)sender{
    NSInteger tag = self.datePicker.tag;
    switch (tag) {
        case START_CELL_ROW:
            self.start = self.datePicker.date;
            break;
        case END_CELL_ROW:
            self.end = self.datePicker.date;
            break;
        default:
            return;
    }

    // reload cells with start and end period
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:
                                            [NSIndexPath indexPathForRow:tag inSection:0], nil] 
                          withRowAnimation:UITableViewRowAnimationNone];
}	

- (void)weekDayControllerDidFinishWithSave:(BOOL) done
{
    if (done)
    {    
        // reload cell with schedule
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects: 
                                                [NSIndexPath indexPathForRow:DAY_CELL_ROW inSection:0], nil] 
                              withRowAnimation:UITableViewRowAnimationNone];
    }    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [[self delegate] periodController:self didFinishWithSave:NO];
}

- (IBAction)done:(id)sender
{
    [[self delegate] periodController:self didFinishWithSave:YES];
}

@end
