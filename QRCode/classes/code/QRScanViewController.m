//
//  QRScanViewController.m
//  QRCode
//
//  Created by winter on 16/1/26.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "QRScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** 输入输出 桥梁 */
@property (nonatomic, strong) AVCaptureSession *avSession;
/** AVCaptureDevice */
@property (nonatomic, weak) AVCaptureDevice *captureDevice;

@end

@implementation QRScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    
    [self configureCaptureDevice];
}

#pragma mark -
#pragma mark - buttonClicledAction

- (IBAction)buttonClicledAction:(UIButton *)sender
{
    if (100 == sender.tag) {
        // 相册
        [self localPhotos];
    }
    else if (101 == sender.tag) {
        // 开灯
        sender.selected = !sender.isSelected;
        [self openFlashLamp:sender.isSelected];
    }
    else {
        // 我的二维码
        [self generateQRCode];
    }
}

- (void)localPhotos
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)openFlashLamp:(BOOL)open
{
    // 锁
    [self.captureDevice lockForConfiguration:nil];
    if (open) {
        // 打开手电筒
        [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
    }
    else {
        [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
    }
    // 解锁
    [self.captureDevice unlockForConfiguration];
}

- (void)generateQRCode
{

}

#pragma mark -
#pragma mark - configureCaptureDevice

- (void)configureCaptureDevice
{
    // 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        return;
    }
//    [device setFlashMode:AVCaptureFlashModeAuto];
    self.captureDevice = device;
    
    // 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理 在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // x:距屏幕顶部 整屏高的倍数(扫描范围距top的距离)，y:距屏幕右边距地倍数(扫描范围距右边的距离)，w:屏高的倍数(扫描范围的高度)，h:屏宽的倍数(扫描范围的宽度)
    output.rectOfInterest=CGRectMake(0.1,0.25,0.3,0.5);
    
    // 初始化链接对象
    self.avSession = [[AVCaptureSession alloc] init];
    // 设置采样率
    [self.avSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.avSession addInput:input];
    [self.avSession addOutput:output];
    
    // 设置扫码支持的编码格式（条码和二维码兼容）
    // 注：设置必须在 [self.avSession addOutput:output]; 执行，否则会crash
    output.metadataObjectTypes = @[
                                   AVMetadataObjectTypeQRCode, //二维码
                                   AVMetadataObjectTypeEAN13Code, //商品条形码
                                   AVMetadataObjectTypeEAN8Code, //商品条形码
                                   AVMetadataObjectTypeCode128Code, //商品条形码
                                   AVMetadataObjectTypeUPCECode, //商品条形码
                                   AVMetadataObjectTypeCode39Code //商品条形码
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
        [self.avSession stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        [self returnBackQRCode:metadataObject.stringValue];
    }
}

// 识别图片的二维码
- (void)identifyQRCode:(UIImage *)image
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    //设置识别参数
    NSDictionary *param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                      forKey:CIDetectorAccuracy];
    //声明一个CIDetector，并设定识别类型
    CIDetector* faceDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                  context:context options:param];
    //取得识别结果
    NSArray *detectResult = [faceDetector featuresInImage:ciImage];
    CIQRCodeFeature *QRCodeFeature = [detectResult firstObject];
    [self returnBackQRCode:QRCodeFeature.messageString];
}

- (void)returnBackQRCode:(NSString *)codeString
{
    NSLog(@"codeString = %@",codeString);
    if (self.QRResultBlock) {
        self.QRResultBlock(codeString);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        [self identifyQRCode:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x0cc1f5"]] forBarMetrics:UIBarMetricsDefault];
        [navigationController.navigationBar setTitleTextAttributes:@{
                                                                     NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:20.f],
                                                                     NSBackgroundColorAttributeName : [UIColor colorWithRed:251.0/255 green:251.0/255 blue:251.0/255 alpha:1.0]
                                                                     }];
        viewController.navigationItem.title = @"相册";
        UIButton *editBtn = [[UIButton alloc] init];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [editBtn setTitle:@"取消" forState:UIControlStateNormal];
        editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [editBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7f] forState:UIControlStateHighlighted];
        [editBtn sizeToFit];
        [editBtn addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        viewController.navigationItem.rightBarButtonItems = @[negativeSpacer,item];
    }
}

- (void)dismissPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
