//
//  EntityTableHeaderController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 30/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
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
    [photoButton release];
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
    
    if (thumbnail)
    {
        [self.photoButton setBackgroundImage:thumbnail forState:UIControlStateNormal];
    }

    if (thumbnailTitle)
    {
        [self.photoButton setTitle:thumbnailTitle forState:UIControlStateNormal];
    }

    if (name) {
        self.nameTextField.text = [NSString stringWithFormat:@" %@", name];
    }
    else {
        self.nameTextField.text = @"";
    }
    self.view.backgroundColor = BACKGROUND_COLOR;
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
    
    self.photoButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
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
    return self.nameTextField.text;
}

- (NSString *)noteFromTextField
{
    return @"note???";
}

- (void)editing:(BOOL)editing
{
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
