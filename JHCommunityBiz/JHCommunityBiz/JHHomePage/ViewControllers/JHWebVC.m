//
//  JHWebVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/18.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHWebVC.h"

@interface JHWebVC ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation JHWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCookie];
    webView = [[UIWebView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT- 64)];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    [self.view addSubview:webView];
    SHOW_HUD
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    HIDE_HUD
    SHOW_HUD
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    HIDE_HUD
    NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
}
-(void)clickBackBtn{
    if (webView.canGoBack) {
        [webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//设置cookie的token
-(void)setCookie{
    if (![self.urlStr containsString:@"http"]) {
        return;
    }
    NSURL *linkUrl = [NSURL URLWithString:self.urlStr];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies];
    NSHTTPCookie *cookie = arr.firstObject;
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionaryWithDictionary:cookie.properties];
    [cookieProperties setObject:linkUrl.host forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"KT-BIZ_TOKEN" forKey:NSHTTPCookieName];
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];

    if (str) {
         [cookieProperties setObject:str forKey:NSHTTPCookieValue];
    }

    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [arr addObject:cookieuser];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:arr forURL:[NSURL URLWithString:self.urlStr] mainDocumentURL:nil];
}
@end
