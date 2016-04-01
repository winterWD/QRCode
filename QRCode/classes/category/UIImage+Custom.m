//
//  UIImage+Custom.m
//  jhjr
//
//  Created by wwinter on 15/12/22.
//  Copyright © 2015年 DJDG. All rights reserved.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)


+ (UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
