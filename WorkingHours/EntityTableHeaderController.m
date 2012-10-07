//
//  EntityTableHeaderController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 30/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Logger.h"
#import "Utils.h"
#import "ImageUtils.h"
#import "EntityTableHeaderController.h"

#define SECTION_INFO 0
#define ROW_NAME 0
#define ROW_NOTE 1

@implementation EntityTableHeaderController

@synthesize thumbnail;
@synthesize thumbnailTitle;
@synthesize name;
@synthesize note;
@synthesize delegate;
@synthesize nameCell = _nameCell;
@synthesize noteCell = _noteCell;
@synthesize tableView;
@synthesize entityEditableCell;
@synthesize photoButton;

#pragma mark - Init dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        TRC_ENTRY
    }
    return self;
}

- (void)dealloc
{
    [thumbnailTitle release];
    [thumbnail release];
    [note release];
    [name release];
    [_nameCell release];
    [_noteCell release];
    [photoButton release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    TRC_ENTRY
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    TRC_ENTRY
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TRC_ENTRY
    
    if (thumbnail)
    {
        [self.photoButton setBackgroundImage:thumbnail forState:UIControlStateNormal];
    }

    if (thumbnailTitle)
    {
        [self.photoButton setTitle:thumbnailTitle forState:UIControlStateNormal];
    }

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [super viewDidUnload];
    TRC_ENTRY
    
    // save state
    self.name = self.nameCell.textField.text;
    self.note = self.noteCell.textField.text;
    
    self.nameCell = nil;
    self.noteCell = nil;
    self.photoButton = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Datasource delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)loadCell:(EntityEditableCell **)cell
{
    [[NSBundle mainBundle] loadNibNamed:@"EntityEditableCell" owner:self options:nil];
    *cell = [entityEditableCell retain];
    self.entityEditableCell = nil;
}

- (EntityEditableCell *)nameCell
{
    if (_nameCell == nil)
    {
        [self loadCell:&_nameCell];
        [_nameCell.textField setDelegate:self];
        [_nameCell.textField setPlaceholder:@"name"]; 
        [_nameCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        TRC_DBG(@"Name cell created");
    }
    return _nameCell;
}

- (EntityEditableCell *)noteCell
{
    if (_noteCell == nil)
    {
        [self loadCell:&_noteCell];
        [_noteCell.textField setDelegate:self];
        [_noteCell.textField setPlaceholder:@"note"];
        [_noteCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        TRC_DBG(@"Note cell created");
    }
    return _noteCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) 
    {
        case ROW_NAME:
            [self.nameCell.textField setText:name];
            [self.nameCell setBackgroundColor:[ImageUtils cellBackGround]];
            return self.nameCell;
        case ROW_NOTE: 
            [self.noteCell.textField setText:note];
            [self.noteCell setBackgroundColor:[ImageUtils cellBackGround]];
            return self.noteCell;
    }
    return nil;
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // hide keyboard whed "done" keyboard button is pressed 
    [textField resignFirstResponder];
    return YES; 
}

#pragma mark - Button sender

- (IBAction)photoButtonTouchUpInside:(id)sender
{
    [self.delegate controller:self photoButtonTouchUpInside:sender];
}

#pragma mark - Setters

- (void)updatePhotoButton:(UIImage *)image withTitle:(NSString *)title
{
    [photoButton setBackgroundImage:image forState:UIControlStateNormal];
    [photoButton setTitle:title forState:UIControlStateNormal];
}

- (void)setThumbnail:(UIImage *)image withTitle:(NSString *)title
{
    TRC_ENTRY
    if (image)
    {
        self.thumbnailTitle = title;

        [thumbnail release];
        thumbnail = [image retain];

        [self updatePhotoButton:image withTitle:title];
    } 
    else 
    {
        [self updatePhotoButton:[ImageUtils imageThumbnailStub] withTitle:self.thumbnailTitle];
    }
}

- (void) resetThumbnail
{
    self.thumbnail = nil;
    self.thumbnailTitle = @"add photo";
    
    [self updatePhotoButton:[ImageUtils imageThumbnailStub] withTitle:self.thumbnailTitle];
}

- (NSString *)nameFromTextField
{
    return self.nameCell.textField.text;
}

- (NSString *)noteFromTextField
{
    return self.noteCell.textField.text;
}

- (void)editing:(BOOL)editing
{
    [self.nameCell.textField setEnabled:editing];
    [self.noteCell.textField setEnabled:editing];
    
    [self.photoButton setSelected:editing];
    [self.photoButton setAdjustsImageWhenHighlighted:editing];
    if (editing)
    {
        self.thumbnailTitle = @"edit photo";
    } 
    else 
    {
        self.thumbnailTitle = @"";
    }
    [photoButton setTitle:thumbnailTitle forState:UIControlStateNormal];
}

@end
