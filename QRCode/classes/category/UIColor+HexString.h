//
//  UIColor+HexString.h
//
//  Created by wd on 15/6/6.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

/**
 *  从十六进制字符串获取颜色
 *
 *  @param color 从十六进制字符串获取颜色   支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *
 *  @return UIColor 如果输入格式不正确，return clearColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  从十六进制字符串获取颜色
 *
 *  @param color 从十六进制字符串获取颜色  支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *  @param alpha 0--1
 *
 *  @return UIColor 如果输入格式不正确，return clearColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
