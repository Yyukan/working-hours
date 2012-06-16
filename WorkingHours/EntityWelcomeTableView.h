//
//  EntityWelcomeTableView.h
//  EntityWelcomeTableView
//
//  Created by Oleksandr Shtykhno on 08/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntityWelcomeTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSString *welcomeText;

- (id)initWithWelcomeText:(NSString *) text;

@end
