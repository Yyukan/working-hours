//
//  SiteController.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 30/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Logger.h"
#import "SiteController.h"

@implementation SiteController

@synthesize url;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        TRC_ENTRY
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    TRC_ENTRY
}

- (void)dealloc
{
    [url release];
    [webView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *nsUrl = [NSURL URLWithString:[@"http://" stringByAppendingString:self.url]];
	[webView loadRequest:[NSURLRequest requestWithURL:nsUrl]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
