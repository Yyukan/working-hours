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

@implementation EntityPeriodController

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

- (void)initializeScheduleAndWeek
{
    // if schedule is set than schedule is edited not added
    if (!_schedule) 
    {
        self.start = [DateUtils dateWithHours:9 andMinutes:0]; 
        self.end = [DateUtils dateWithHours:18 andMinutes:0];
        self.week = [Week defaultWeek];
    }
    else 
    {
        self.start = _schedule.start;
        self.end = _schedule.end;
        self.week = [Week weekFromSchedule:_schedule];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Schedule";

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"done"] style:UIBarButtonItemStylePlain target:self action:@selector(done:)] autorelease];
    
    self.navigationController.navigationBar.tintColor = GREEN_COLOR;
    
    [self initializeScheduleAndWeek];

    [self.startTime setTitle:[DateUtils formatTimeTo24Hours:self.start] forState:UIControlStateNormal];
    [self.stopTime setTitle:[DateUtils formatTimeTo24Hours:self.end] forState:UIControlStateNormal];
    
    [self initializeButtonsFromWeek:MONDAY button:self.mondayButton];
    [self initializeButtonsFromWeek:TUESDAY button:self.tuesdayButton];
    [self initializeButtonsFromWeek:WEDNESDAY button:self.wednesdayButton];
    [self initializeButtonsFromWeek:THURSDAY button:self.thursdayButton];
    [self initializeButtonsFromWeek:FRIDAY button:self.fridayButton];
    [self initializeButtonsFromWeek:SATURDAY button:self.saturdayButton];
    [self initializeButtonsFromWeek:SUNDAY button:self.sundayButton];

    [self.datePicker setHidden:YES];
    [self.datePicker addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
}

- (void) initializeButtonsFromWeek:(Week *)day button:(UIButton *)button
{
    [button setBackgroundImage:[ImageUtils imageWithColor:GREEN_COLOR] forState:UIControlStateSelected | UIControlStateHighlighted];
    [button setBackgroundImage:[ImageUtils imageWithColor:BLACK_COLOR] forState:UIControlStateNormal];

    if ([self.week checkDay:day]) {
        button.selected = YES;
        button.highlighted = YES;
    } else {
        button.selected = NO;
        button.highlighted = NO;
    }
}

- (void) initializeWeekFromButtons:(UIButton *)button day:(Week *)day
{
    if (button.selected) {
        [self.week includeDay:day];
    }
    else {
        [self.week excludeDay:day];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(void)showTimePicker:(NSDate *)date withTag:(NSInteger) tag;
{
    self.datePicker.date = [date.copy autorelease];
    self.datePicker.tag = tag;
    self.datePicker.hidden = NO;
}

- (void)changeDateInLabel:(id)sender{
    NSInteger tag = self.datePicker.tag;
    switch (tag) {
        case START_TIME_TAG:
            self.start = self.datePicker.date;
            [self.startTime setTitle:[DateUtils formatTimeTo24Hours:self.start] forState:UIControlStateNormal];

            break;
        case STOP_TIME_TAG:
            self.end = self.datePicker.date;
            [self.stopTime setTitle:[DateUtils formatTimeTo24Hours:self.end] forState:UIControlStateNormal];

            break;
        default:
            return;
    }
}

- (IBAction)cancel:(id)sender
{
    [[self delegate] periodController:self didFinishWithSave:NO];
}

- (IBAction)done:(id)sender
{
    [self initializeWeekFromButtons:self.mondayButton day:MONDAY];
    [self initializeWeekFromButtons:self.tuesdayButton day:TUESDAY];
    [self initializeWeekFromButtons:self.wednesdayButton day:WEDNESDAY];
    [self initializeWeekFromButtons:self.thursdayButton day:THURSDAY];
    [self initializeWeekFromButtons:self.fridayButton day:FRIDAY];
    [self initializeWeekFromButtons:self.saturdayButton day:SATURDAY];
    [self initializeWeekFromButtons:self.sundayButton day:SUNDAY];
    
    [[self delegate] periodController:self didFinishWithSave:YES];
}

- (void)highlightButton:(UIButton *)button
{
    [button setHighlighted:YES];
}

- (IBAction)buttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;

    if ([button isSelected]) {
        button.selected = NO;
     } else {
        button.selected = YES;
     }
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
}

- (IBAction)selectStartTime:(id)sender
{
    [self showTimePicker:self.start withTag:START_TIME_TAG];
}

- (IBAction)selectStopTime:(id)sender
{
    [self showTimePicker:self.end withTag:STOP_TIME_TAG];
}
@end
