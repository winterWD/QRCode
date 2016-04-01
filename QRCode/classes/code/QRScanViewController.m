//
//  QRScanViewController.m
//  QRCode
//
//  Created by winter on 16/1/26.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "QRScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

/** 输入输出 桥梁 */
@property (nonatomic, strong) AVCaptureSession *avSession;

@end

@implementation QRScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    
    [self configureSubViews];
}

- (void)configureSubViews
{
    // 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        return;
    }
    
//    //创建输入流
//    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    //创建输出流
//    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
//    //设置代理 在主线程里刷新
//    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    //初始化链接对象
//    self.avSession = [[AVCaptureSession alloc]init];
//    //高质量采集率
//    [self.avSession setSessionPreset:AVCaptureSessionPresetHigh];
//    
//    [self.avSession addInput:input];
//    [self.avSession addOutput:output];
//    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//    
//    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.avSession];
//    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
//    layer.frame=self.view.layer.bounds;
//    [self.view.layer insertSublayer:layer atIndex:0];
//    //开始捕获
//    [self.avSession startRunning];
    
    // 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理 在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    output.rectOfInterest=CGRectMake(0.0,0.5,0.5,0.5);
    
    // 初始化链接对象
    self.avSession = [[AVCaptureSession alloc] init];
    // 设置采样率
    [self.avSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.avSession addInput:input];
    [self.avSession addOutput:output];
    
    // 设置扫码支持的编码格式（条码和二维码兼容）
    output.metadataObjectTypes = @[
                                   AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code
                                   ];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.avSession];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    // 开始捕获
    [self.avSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    }
}
@end
