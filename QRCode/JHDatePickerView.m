//
//  JHDatePickerView.m
//  Code
//
//  Created by winter on 16/1/26.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "JHDatePickerView.h"

@interface JHDatePickerView ()
@property (strong, nonatomic) UIDatePicker *datePicker;
@end
@implementation JHDatePickerView

+ (instancetype)datePickerViewWithFrame:(CGRect)frame
{
    JHDatePickerView *datePickerView = [[JHDatePickerView alloc] initWithFrame:frame];
    return datePickerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect tempFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 216);
    if (self = [super initWithFrame:tempFrame]) {
        [self setupDatePickerView];
    }
    return self;
}

- (void)setupDatePickerView
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 216)];
    
    [self.datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.datePicker];
}

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    NSDate *selectedDate = [sender date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init ];
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *newDateString = [outputFormatter stringFromDate:selectedDate];
    if (self.dateResultBlock) {
        self.dateResultBlock(newDateString);
    }
}
@end
