//
//  CountryController.h
//  CountrySelector
//
//  Created by Oleksandr Shtykhno on 03/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryControllerDelegate;

@interface CountryController : UITableViewController
{
    @private
    NSDictionary *_countries;
    NSArray *_sections;
}
@property (nonatomic, assign) id <CountryControllerDelegate> delegate;

@end


@protocol CountryControllerDelegate

- (void)controller:(CountryController *)controller didSelectCountry:(NSString *)country;

@end
