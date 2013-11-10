//
//  ImageUtils.h
//  WorkingHours
//
//  Created by Oleksandr Shtykhno on 19/09/2011.
//  Copyright 2011 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#define THUMBNAIL_SIZE 176.0

@interface ImageUtils : NSObject

+ (UIImage*)image:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)targetSize;
+ (UIImage*)rotate:(UIImage *)image orientation:(UIImageOrientation)orientation;
+ (UIImage*)thumbnailWithImage:(UIImage *)image size:(float) size;
+ (UIImage*)imageThumbnailStub;
+ (int)size:(UIImage *)image;
+ (void)setBackgroundImage:(UIView *)view;
+ (void)setBackgroundColor:(UIView *)view;

+ (UIColor *)cellBackGround;
+ (UIColor *)tintColor;

+ (void)setSeparatorColor:(UITableView *)tableView;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
