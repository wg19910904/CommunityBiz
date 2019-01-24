//
//  JHTuanProductDescVC.m
//  JHCommunityBiz
//
//  Created by jianghu2 on 16/11/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuanProductDescVC.h"
#import "NJKWebViewProgress.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NJKWebViewProgressView.h"
#import "RegexKitLite.h"
@interface JHTuanProductDescVC ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,strong)UIWebView *descWebView;
@property (nonatomic,strong)NJKWebViewProgress *progressProxy;
@property (nonatomic,strong)NJKWebViewProgressView *progressView;//进度条
@property (nonatomic,strong)JSContext *context;
@end

@implementation JHTuanProductDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"商品描述", nil);
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
    [self.view addSubview:self.descWebView];
}
- (UIWebView *)descWebView{
    if(_descWebView == nil){
        _descWebView = [UIWebView new];
        _descWebView.delegate = self.progressProxy;
        _descWebView.frame = FRAME(0, 0, WIDTH, HEIGHT - 64);
        _descWebView.opaque = NO;
        _descWebView.scrollView.scrollEnabled = NO;
        _descWebView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:self.progressView];
        [_descWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",KReplace_Url,@"/tuan/product/tuwendetail2"]]]];
    }
    return _descWebView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    __unsafe_unretained typeof (self)weakSelf = self;
    self.context[@"app_html"] = ^(NSString *htmlStr){
        if(weakSelf.activityInfoBlock){
            weakSelf.activityInfoBlock(htmlStr);
        }
        [weakSelf clickBackBtn];
    };
    NSString *valueStr = [self.htmlStr stringByReplacingOccurrencesOfRegex:@"\"" withString:@"\\\""];
    NSString *valueStr1 = [valueStr stringByReplacingOccurrencesOfRegex:@"\n" withString:@"\\\\n"];
    NSString *evaluate = [NSString stringWithFormat:@"%@('%@');",@"set_content",valueStr1];
    [self.context evaluateScript:evaluate];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (JSContext *)context{
    if(_context == nil){
        _context = [self.descWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    return _context;
}
- (NJKWebViewProgress *)progressProxy{
    
    if(_progressProxy == nil){
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}
- (NJKWebViewProgressView *)progressView{
    if(_progressView == nil){
        CGFloat progressBarHeight = 2.0f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, 0, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _progressView;
}
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [self.progressView setProgress:progress animated:YES];
}
- (void)clickBackBtn{
    if(self.descWebView.canGoBack)
        [self.descWebView goBack];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.descWebView addSubview:self.progressView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}
- (void)keyboardDidShow:(NSNotification *)noti
{
    NSDictionary* info = [noti userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    //获取内容的高度
    CGFloat content_height  = self.descWebView.scrollView.contentSize.height;
    [self.descWebView.scrollView setContentOffset:CGPointMake(0, content_height-kbSize.height-50) animated:YES];
}
- (void)keyboardDidHide:(NSNotification *)noti
{
    self.descWebView.frame = FRAME(0, 0, WIDTH, HEIGHT - 64);
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//     [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
//     [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidHideNotification];
}
@end
