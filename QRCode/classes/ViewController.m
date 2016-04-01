//
//  ViewController.m
//  QRCode
//
//  Created by winter on 16/1/26.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "ViewController.h"
#import "QRScanViewController.h"
#import "JHDatePickerView.h"
#import "WDNavigationController.h"

@interface ViewController ()
/** JHDatePickerView */
@property (nonatomic, strong)  JHDatePickerView *dataPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码/条码识别";
    
    self.dataPickerView = [[JHDatePickerView alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 0)];
    [self.view addSubview:self.dataPickerView];
    self.dataPickerView.dateResultBlock = ^(NSString *dateString){
        NSLog(@"date: %@",dateString);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)QRCodeButtonClicked:(UIButton *)sender
{
    QRScanViewController *QRVC = [[QRScanViewController alloc] initWithNibName:@"QRScanViewController" bundle:nil];
    [self.navigationController pushViewController:QRVC animated:YES];
//    WDNavigationController *nav = [[WDNavigationController alloc] initWithRootViewController:QRVC];
//    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)barCodeButtonClicked:(UIButton *)sender
{
    
}

@end
