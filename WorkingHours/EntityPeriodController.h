//
//  EntityPeriodController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 13/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityWeekDayController.h"
#import "Schedule.h"
#import "Week.h"

#define START_CELL_ROW 0
#define END_CELL_ROW 1
#define DAY_CELL_ROW 2

@protocol EntityPeriodControllerDelegate;

@interface EntityPeriodController : UITableViewController <UIPickerViewDelegate, EntityWeekDayControllerDelegate>
{
    @private
    Schedule *_schedule;
    // start date of period (time)
    NSDate *_start;
    // end date of period (time)
    NSDate *_end;
    // week schedule
    Week *_week;
    // date picker for start and end date
    UIDatePicker *_datePicker;
}
@property (nonatomic, copy) NSDate *start;
@property (nonatomic, copy) NSDate *end;
@property (nonatomic, retain) Schedule *schedule;
@property (nonatomic, retain) Week *week;
@property (nonatomic, retain) UIDatePicker *datePicker;

@property (nonatomic, assign) id<EntityPeriodControllerDelegate> delegate;
@end

@protocol EntityPeriodControllerDelegate
-(void)periodController:(EntityPeriodController *)controller didFinishWithSave:(BOOL)done;
@end
