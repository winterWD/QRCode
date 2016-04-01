//
//  UIColor+HexString.m
//
//  Created by wd on 15/6/6.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)


/**
 *  从十六进制字符串获取颜色
 *
 *  @param color 从十六进制字符串获取颜色  支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *
 *  @return UIColor 如果输入格式不正确，return clearColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    if (hexString) {
        return [self colorWithHexString:hexString alpha:1.0];
    } else {
        return [UIColor clearColor];
    }
}

/**
 *  从十六进制字符串获取颜色
 *
 *  @param color 从十六进制字符串获取颜色  支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *  @param alpha 0--1
 *
 *  @return UIColor 如果输入格式不正确，return clearColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    if (!hexString) return [UIColor clearColor];
    
    //删除字符串中的空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    else if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
