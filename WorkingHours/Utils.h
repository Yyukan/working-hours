//
//  Utils.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 27/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define SHOW_OK_CANCEL_ACTION 1
#define ADD_PHOTO_ACTION_SHEET 100
#define EDIT_PHOTO_ACTION_SHEET 101

@interface Utils : NSObject

+ (void)tableViewController:(UITableViewController*) controller presentModal:(UIViewController *)modal;
+ (void)showRequiredNameAlert;

+ (void)showOKCancelAction:(UIView*)view withOkTitle:(NSString *)titleOk delegate:(id<UIActionSheetDelegate>) delegate;
+ (void)showAddPhotoAction:(UIView*)view delegate:(id<UIActionSheetDelegate>) delegate;
+ (void)showEditPhotoAction:(UIView*)view delegate:(id<UIActionSheetDelegate>) delegate;

+ (CGPoint)adjustPosition:(CGFloat)x :(CGFloat)y :(CGFloat)diffX :(CGFloat)diffY;

+ (UIView *)emptyView;
//
// Functions to work with tables
//
+ (UITableViewCell *)tableView:(UITableView *)tableView cellInsert:(NSIndexPath *)indexPath identifier:(NSString *)identifier text:(NSString *)text;
+ (void)adjustHeadTail:(UITableViewCell *)cell;

@end
