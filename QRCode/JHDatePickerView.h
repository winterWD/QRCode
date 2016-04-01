//
//  JHDatePickerView.h
//  Code
//
//  Created by winter on 16/1/26.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHDatePickerView : UIView

/** 选择日期结果 @"YYYY-MM-dd" */
@property (nonatomic, copy) void(^dateResultBlock)(NSString *dateString);

@end
