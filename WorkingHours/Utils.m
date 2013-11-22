//
//  Utils.m
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 27/08/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//
#import "Common.h"
#import "Logger.h"
#import "Utils.h"
#import "ImageUtils.h"

@implementation Utils

+ (void)tableViewController:(UITableViewController*) controller presentModal:(UIViewController *)modal;
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:modal];

    [controller presentViewController:navigationController animated:NO completion:nil];
	
    [navigationController release];
}

+ (void)showRequiredNameAlert 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                    message:@"Please enter name"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Action sheets
//

+ (void)showOKCancelAction:(UIView*)view withOkTitle:(NSString *)titleOk delegate:(id<UIActionSheetDelegate>) delegate
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:delegate cancelButtonTitle:@"Cancel" destructiveButtonTitle: titleOk otherButtonTitles:nil];
	actionSheet.tag = SHOW_OK_CANCEL_ACTION; 
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:view]; 
	[actionSheet release];
}

+ (void)showAddPhotoAction:(UIView*)view delegate:(id<UIActionSheetDelegate>) delegate
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:delegate cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle: nil otherButtonTitles:@"Take photo", @"Choose photo", nil];
    actionSheet.tag = ADD_PHOTO_ACTION_SHEET;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:view]; 
	[actionSheet release];
}

+ (void)showEditPhotoAction:(UIView*)view delegate:(id<UIActionSheetDelegate>) delegate
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:delegate cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle: nil 
                                                    otherButtonTitles:@"Take photo", @"Choose photo", @"Delete photo", nil];
    actionSheet.tag = EDIT_PHOTO_ACTION_SHEET;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:view]; 
	[actionSheet release];
}

+ (CGPoint)adjustPosition:(CGFloat)x :(CGFloat)y :(CGFloat)diffX :(CGFloat)diffY
{
    CGPoint position;
    position.x = x + diffX;
    position.y = y + diffY; 
    return position;
}

/**
 * Creates cell for insert with identifer and simple text, identifier should be static string declared before
 */
+ (UITableViewCell *)tableView:(UITableView *)tableView cellInsert:(NSIndexPath *)indexPath identifier:(NSString *)identifier text:(NSString *)text
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = GLOBAL_CELL_SELECTION_STYLE;
    }
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    cell.textLabel.textColor = BACKGROUND_COLOR;

    [cell setBackgroundColor:BLACK_COLOR];
    [Utils adjustHeadTail:cell];

    return cell;
}

+ (void)adjustHeadTail:(UITableViewCell *)cell
{
    UIView *headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, cell.frame.size.height)] autorelease];
    headView.backgroundColor = BACKGROUND_COLOR;
    
    UIView *tailView = [[[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width-5, 0, 10, cell.frame.size.height)] autorelease];
    tailView.backgroundColor = BACKGROUND_COLOR;
    
    [cell addSubview:headView];
    [cell addSubview:tailView];
}

+ (void)adjustHeadTail:(UITableViewCell *)cell height:(CGFloat)height
{
    UIView *headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, height)] autorelease];
    headView.backgroundColor = BACKGROUND_COLOR;
    
    UIView *tailView = [[[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width-5, 0, 10, height)] autorelease];
    tailView.backgroundColor = BACKGROUND_COLOR;
    
    [cell addSubview:headView];
    [cell addSubview:tailView];
}


+ (UIView *)emptyView
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

@end
