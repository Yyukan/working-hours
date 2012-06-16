//
//  SiteController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 30/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiteController : UIViewController

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
