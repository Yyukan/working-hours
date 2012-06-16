//
//  EntityWelcomeTableView.m
//  EntityWelcomeTableView
//
//  Created by Oleksandr Shtykhno on 08/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import "EntityWelcomeTableView.h"

#define FRAME CGRectMake(0.0f, 0.0f, 200.0f, 150.0f)
#define HEIGHT_FOR_ROW 130.0f;

@implementation EntityWelcomeTableView

@synthesize welcomeText = _welcomeText;

- (id)initWithWelcomeText:(NSString *) text;
{
    self = [super initWithFrame:FRAME style:UITableViewStyleGrouped];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.scrollEnabled = NO;
        self.welcomeText = text;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)dealloc {
    [_welcomeText release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_FOR_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WelcomeTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 5;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = self.welcomeText;
    return cell;
    
}
@end
