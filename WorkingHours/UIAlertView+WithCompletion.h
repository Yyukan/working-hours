//
//  UIAlertView+WithCompletion.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 23/11/2013.
//  Copyright (c) 2013 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView (WithCompletion)

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end