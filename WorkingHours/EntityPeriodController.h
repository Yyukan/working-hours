//
//  EntityPeriodController.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 13/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "Week.h"

#define START_TIME_TAG 1
#define STOP_TIME_TAG 2

@protocol EntityPeriodControllerDelegate;

@interface EntityPeriodController : UIViewController <UIPickerViewDelegate>
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
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIButton *mondayButton;
@property (nonatomic, retain) IBOutlet UIButton *tuesdayButton;
@property (nonatomic, retain) IBOutlet UIButton *wednesdayButton;
@property (nonatomic, retain) IBOutlet UIButton *thursdayButton;
@property (nonatomic, retain) IBOutlet UIButton *fridayButton;
@property (nonatomic, retain) IBOutlet UIButton *saturdayButton;
@property (nonatomic, retain) IBOutlet UIButton *sundayButton;

@property (nonatomic, retain) IBOutlet UIButton *startTime;
@property (nonatomic, retain) IBOutlet UIButton *stopTime;

@property (nonatomic, assign) id<EntityPeriodControllerDelegate> delegate;
@end

@protocol EntityPeriodControllerDelegate
-(void)periodController:(EntityPeriodController *)controller didFinishWithSave:(BOOL)done;
@end
