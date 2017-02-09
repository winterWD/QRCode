//
//  JHWebViewController.h
//  jhjr
//
//  Created by winter on 16/3/23.
//  Copyright © 2016年 DJDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWebViewController : UIViewController

+ (instancetype)webViewControllerWithUrl:(NSString *)url;
+ (instancetype)webViewControllerWithURL:(NSURL *)URL;

@end
