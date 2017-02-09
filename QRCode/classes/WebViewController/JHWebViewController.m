//
//  JHWebViewController.m
//  jhjr
//
//  Created by winter on 16/3/23.
//  Copyright © 2016年 DJDG. All rights reserved.
//

#import "JHWebViewController.h"
#import <WebKit/WebKit.h>

#define JHBaseURLScheme     @"jihe365.cn"

@interface UIButton (Custom)
+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
@implementation UIButton (Custom)

+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [button setTitle:title forState:UIControlStateNormal];
    //    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3f] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
@end

@interface JHWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

/** URL */
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *loadingProgressView;

/** 关闭 */
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
/** 返回 */
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
/** 分享 */
@property (nonatomic, weak) UIBarButtonItem *shareButtonItem;

@property (nonatomic, getter=isCanBack) BOOL canBack;

@property (nonatomic, copy) NSString *webTitle;
@end

@implementation JHWebViewController

+ (instancetype)webViewControllerWithUrl:(NSString *)url
{
    NSURL *URL = [NSURL URLWithString:url];
    return [self webViewControllerWithURL:URL];
}

+ (instancetype)webViewControllerWithURL:(NSURL *)URL
{
    JHWebViewController *instance = [[JHWebViewController alloc] init];
    instance.URL = URL;
    return instance;
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.canBack = YES;
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.loadingProgressView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    
    [self setupUsbViews];
}

- (void)setupUsbViews
{
    UIButton *closeButton = [UIButton buttonWithTitle:@"关闭" target:self action:@selector(buttonClickedAction:)];
    closeButton.tag = 100;
    closeButton.titleEdgeInsets = UIEdgeInsetsMake(.5, -10, 0, 0);
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    self.closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UIButton * backButton = [UIButton buttonWithTitle:@"返回" target:self action:@selector(buttonClickedAction:)];
    [backButton setTitleColor:[UIColor colorWithWhite:1 alpha:1]  forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7]  forState:UIControlStateHighlighted];
    [backButton setImage:[UIImage imageNamed:@"icon_retun_15x15"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_retun_sel_15x15"] forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(.5, -15, 0, 0);
    backButton.frame = CGRectMake(CGRectGetMinX(backButton.frame), CGRectGetMinY(backButton.frame), CGRectGetWidth(backButton.frame)+5, CGRectGetHeight(backButton.frame));
    self.backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationItem setLeftBarButtonItems:@[self.backButtonItem]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareClickedAction)];
    self.shareButtonItem = rightItem;
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

#pragma mark - private method

- (void)shareClickedAction
{
    // 设置分享的内容
    NSString *textToShare = self.webTitle;
    NSURL *urlToShare = self.URL;
    
    NSArray *shareItems = @[
                            textToShare,
                            urlToShare];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    activity.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover) {
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [self presentViewController:activity animated:YES completion:NULL];
}

- (void)buttonClickedAction:(UIButton *)sender
{
    [self updateNavigationItems];
    if (100 != sender.tag) {
        if ([self.webView canGoBack] && self.isCanBack) {
            [self.webView goBack];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateNavigationItems
{
    if ([self.webView canGoBack]) {
        [self.navigationItem setLeftBarButtonItems:@[self.backButtonItem, self.closeButtonItem] animated:NO];
    }
    else {
        [self.navigationItem setLeftBarButtonItems:@[self.backButtonItem] animated:NO];
    }
    self.shareButtonItem.enabled = YES;
}

- (BOOL)webViewLinkCanLoad:(NSString *)linkStr
{
    if ([linkStr hasPrefix:@"http://"] || [linkStr hasPrefix:@"https://"] ) {
        return YES;
    }
    
    [self analyseWebViewLinkString:linkStr];
    
    return NO;
}

#pragma mark - webView action

- (void)analyseWebViewLinkString:(NSString *)linkStr
{
//    [self analyseWebViewLinkStr:linkStr responseLink:^(NSString *linkString) {
//        if (linkString.length > 0) {
//            [self setParams:linkString];
//            self.canBack = NO;
//            [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
//        }
//    }];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest *request = navigationAction.request;
    NSString *linkStr = [request.URL absoluteString];
    [self webViewLinkCanLoad:linkStr];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    _loadingProgressView.hidden = NO;
    self.shareButtonItem.enabled = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self updateNavigationItems];
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString * _Nullable title, NSError * _Nullable error) {
        self.webTitle = title;
        if (title.length > 10) {
            title = [[title substringToIndex:9] stringByAppendingString:@"..."];
        }
        self.title = title;
    }];
}

#pragma mark - observeValueForKeyPath

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.loadingProgressView.progress = [change[@"new"] floatValue];
        if (self.loadingProgressView.progress == 1.0) {
            double delaySeconds = 0.4;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                // method
                self.loadingProgressView.hidden = YES;
            });
        }
    }
}

#pragma mark - getter && setter

- (WKWebView *)webView
{
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)
                                     configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        
        //添加此属性可触发侧滑返回上一网页与下一网页操作
        _webView.allowsBackForwardNavigationGestures = YES;

        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}

- (UIProgressView *)loadingProgressView
{
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 2)];
        _loadingProgressView.progressTintColor = [UIColor colorWithHexString:@"#00BB29"];
    }
    return _loadingProgressView;
}
@end
