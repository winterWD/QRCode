//
//  WDNavigationController.m
//  winterTest
//
//  Created by wd on 15/11/3.
//  Copyright © 2015年 winter. All rights reserved.
//

#import "WDNavigationController.h"

@interface WDNavigationController ()

@end

@implementation WDNavigationController

+ (void)initialize
{
    [self setUpNavigationBar];
    [self setUpButtonItem];
}

+ (void)setUpNavigationBar
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[WDNavigationController class], nil];
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x0cc1f5"]] forBarMetrics:UIBarMetricsDefault];
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor whiteColor],
                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:16.f]
                                     }];
    // 导航条阴影
    [navBar setShadowImage:[UIImage new]];
    
    // 模糊效果
    [navBar setTranslucent:NO];
}

+ (void)setUpButtonItem
{
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    
    // 设置字体颜色
    [barButtonItem setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor whiteColor],
                                            NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                                            [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] : NSShadowAttributeName
                                            } forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7],
                                            NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                                            } forState:UIControlStateHighlighted];
    
    // 设置图片
    UIImage *defaultImage = [UIImage imageNamed:@"icon_retun_15x15"];
    [defaultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *highlightedImage = [UIImage imageNamed:@"icon_retun_sel_15x15"];
    [highlightedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [barButtonItem setBackButtonBackgroundImage:[defaultImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, defaultImage.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackButtonBackgroundImage:[highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, highlightedImage.size.width, 0, 0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    // 调整文字与图片间距
    [barButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-5, -2) forBarMetrics:UIBarMetricsDefault];
    
    // 设置barButtonItem  无 背景
    [barButtonItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置下一个viewController的返回按钮内容
        UIViewController *fromVC = [self.viewControllers lastObject];
        NSString *backItemTitle = fromVC.title;
        if (!backItemTitle) {
            backItemTitle = @"返回";
        }
        else if (backItemTitle.length > 4) {
            NSString *tempStr = [backItemTitle substringToIndex:3];
            backItemTitle = [NSString stringWithFormat:@"%@...",tempStr];
        }
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:backItemTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        self.visibleViewController.navigationItem.backBarButtonItem = backButtonItem;
    }
    [super pushViewController:viewController animated:animated];
}

//- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//
//}
//
//- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
//{
//    
//}

@end
