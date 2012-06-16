//
//  EntityWeekDayController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 13/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Week;

@protocol EntityWeekDayControllerDelegate;

@interface EntityWeekDayController : UITableViewController
{    
    @private
    Week *_week;
}    
@property (nonatomic, retain) Week *week;
@property (nonatomic, assign) id <EntityWeekDayControllerDelegate> delegate;

@end

@protocol EntityWeekDayControllerDelegate

- (void)weekDayControllerDidFinishWithSave:(BOOL)done;

@end