//
//  QRScanViewController.h
//  QRCode
//
//  Created by winter on 16/1/26.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRScanViewController : UIViewController

@property (nonatomic, copy) void (^QRResultBlock)(NSString *result);
@end
