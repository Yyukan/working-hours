//
//  EntityWeekDayController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 13/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import "Logger.h"
#import "ImageUtils.h"
#import "EntityWeekDayController.h"
#import "Week.h"

@implementation EntityWeekDayController

@synthesize delegate;
@synthesize week = _week;

-(void) dealloc
{
    [_week release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    TRC_ENTRY
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"";
    self.navigationItem.leftBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                   target:self action:@selector(cancel:)] autorelease];

    self.navigationItem.rightBarButtonItem = 
    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                   target:self action:@selector(done:)] autorelease];
    self.editing = NO;
    
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
    return WEEK_SIZE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"DayOfWeekCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }   
    
    cell.textLabel.text = [Week dayLongNameByNumber:indexPath.row];

    if ([_week checkDay:indexPath.row])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } 
    else 
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [ImageUtils cellBackGround];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ([_week checkDay:indexPath.row])
    {
        // excluding last day is not allowed
        if ([_week countDay] == 1) return;
        [_week excludeDay:indexPath.row];
    }
    else
    {
        [_week includeDay:indexPath.row];
    }
    
    [tableView reloadData];
}

- (IBAction)cancel:(id)sender
{
    [[self delegate] weekDayControllerDidFinishWithSave:NO]; 
}

- (IBAction)done:(id)sender
{
    [[self delegate] weekDayControllerDidFinishWithSave:YES]; 
}

@end
