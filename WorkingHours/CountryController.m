//
//  CountryController.m
//  CountrySelector
//
//  Created by Oleksandr Shtykhno on 03/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
#import "Logger.h"
#import "Utils.h"
#import "ImageUtils.h"
#import "CountryController.h"

#define COUNTRY_FILE @"Countries"

@implementation CountryController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:COUNTRY_FILE ofType:@"plist"];
        
        _countries = [[NSDictionary dictionaryWithContentsOfFile:path] retain];
    }
    return self;
}

- (void)dealloc
{
    [_sections release];
    [_countries release];
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

    self.title = @"";
    self.navigationController.navigationBar.tintColor = [ImageUtils tintColor];
    self.tableView.backgroundColor = [UIColor clearColor];

    [ImageUtils setBackgroundImage:self.view];
    [ImageUtils setSeparatorColor:self.tableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source
- (UIImage *)countryFlag:(NSDictionary *)country
{
    NSString *path = [[NSBundle mainBundle]pathForResource:[country objectForKey:@"flag"] ofType:@"gif" inDirectory:@"flags"];

    UIImage *image = [UIImage imageWithContentsOfFile:path];

    return [ImageUtils image:image scaledToSize:CGSizeMake(30, 20)];
}

- (NSArray *)sections
{
    if (!_sections) 
    {
        _sections = [[[_countries allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
    }
    return _sections;
}

- (NSDictionary *)countryAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *countriesInSection = [_countries objectForKey:[_sections objectAtIndex:indexPath.section]];
    return [countriesInSection objectAtIndex:indexPath.row];
}                       

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_countries objectForKey:[_sections objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = GLOBAL_CELL_SELECTION_STYLE;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *country = [self countryAtIndexPath:indexPath];
    
    cell.textLabel.text = [country objectForKey:@"name"];
    cell.imageView.image = [self countryFlag:country];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)section atIndex:(NSInteger)index
{
    return [_sections indexOfObject:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *country = [self countryAtIndexPath:indexPath];
        
    [self.delegate controller:self didSelectCountry:[country objectForKey:@"name"]];
}

@end
