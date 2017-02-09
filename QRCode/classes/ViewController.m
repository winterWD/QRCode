//
//  ViewController.m
//  QRCode
//
//  Created by winter on 16/1/26.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "ViewController.h"
#import "QRScanViewController.h"
#import "WDNavigationController.h"
#import "JHWebViewController.h"

@interface ViewController ()
@property (nonatomic, weak) UILabel *QRResultLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    self.title = @"二维码/条码识别";
    
    UILabel *QRResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 100)];
    QRResultLabel.numberOfLines = 0;
    QRResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:QRResultLabel];
    self.QRResultLabel = QRResultLabel;
    self.QRResultLabel.textColor = [UIColor blueColor];
    
    self.QRResultLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resultAction)];
    [self.QRResultLabel addGestureRecognizer:tap];
#endif
}

- (void)resultAction
{
    NSString *link = self.QRResultLabel.text;
    if ([link containsString:@"http"]) {
        [self pushToWebViewControllerWithLink:link];
    }
}

- (void)pushToWebViewControllerWithLink:(NSString *)link
{
    JHWebViewController *toViewController = [JHWebViewController webViewControllerWithUrl:link];
    [self.navigationController pushViewController:toViewController animated:YES];
}

- (IBAction)QRCodeButtonClicked:(UIButton *)sender
{
    QRScanViewController *QRVC = [[QRScanViewController alloc] initWithNibName:@"QRScanViewController" bundle:nil];
    [self.navigationController pushViewController:QRVC animated:YES];
//    WDNavigationController *nav = [[WDNavigationController alloc] initWithRootViewController:QRVC];
//    [self presentViewController:nav animated:YES completion:nil];
    
    QRVC.QRResultBlock = ^(NSString *result){
        self.QRResultLabel.text = result;
    };
}

- (IBAction)barCodeButtonClicked:(UIButton *)sender
{
    
}

@end
