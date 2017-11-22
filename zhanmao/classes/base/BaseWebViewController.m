//
//  BaseWebViewController.m
//  yangsheng
//
//  Created by jam on 17/7/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "BaseWebViewController.h"
#import "ZZUrlTool.h"
#import "ZZHttpTool.h"
#import "UserModel.h"
//#import "WBWebProgressBar.h"

@interface BaseWebViewController ()<UIWebViewDelegate>
{
    UIView* bottomBg;
}
@property (nonatomic,strong) UIWebView* ios8WebView;

@end

@implementation BaseWebViewController
{
    UIImageView* loadingImageView;
    UIActivityIndicatorView* loadingIndicator;
}

-(instancetype)initWithUrl:(NSURL *)url
{
    self=[super init];
    _url=url;
    return self;
}

-(instancetype)initWithHtml:(NSString *)html
{
    self=[super init];
    _html=html;
    return self;
}

-(void)setBottomView:(UIView *)bottomView
{
    _bottomView=bottomView;
    if (bottomView!=nil) {
        [bottomView removeAllSubviews];
        if (bottomBg==nil) {
            bottomBg=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
            bottomBg.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:bottomBg];
            
            UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomBg.frame.size.width, 1/[[UIScreen mainScreen]scale])];
            line.backgroundColor=gray_8;
            [bottomBg addSubview:line];
        }
        [bottomBg insertSubview:bottomView atIndex:0];
//        bottomView.frame=bottomBg.bounds;
        
    }
}

-(CGRect)bottomBgBounds
{
    return CGRectMake(0, 0, self.view.frame.size.width, 64);
}

-(void)dealloc
{
    self.ios8WebView.delegate=nil;
    
    NSLog(@"%@ deal",NSStringFromClass([self class]));
}

-(UIWebView*)ios8WebView
{
    if (_ios8WebView==nil) {
        _ios8WebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
        
        //uiwebview's
        _ios8WebView.dataDetectorTypes=UIDataDetectorTypeNone;
        _ios8WebView.delegate=self;
        
        //wkwebview's
//        _ios8WebView.navigationDelegate=self;
//        _ios8WebView.UIDelegate=self;
        [self.view addSubview:_ios8WebView];
    }
    NSLog(@"uiwebview");
    return _ios8WebView;
}

-(UIView*)webUIView
{
    return self.ios8WebView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.bottomView) {
        self.ios8WebView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
        bottomBg.frame=CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64);
    }
    else
    {
        self.ios8WebView.frame=self.view.bounds;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    loadingIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingIndicator.center=CGPointMake(self.view.center.x, 64);
    loadingIndicator.hidesWhenStopped=YES;
//    loadingIndicator.backgroundColor=[UIColor redColor];
    [loadingIndicator stopAnimating];
    [self.view addSubview:loadingIndicator];
    
    
    if(self.html.length>0)
    {
        [self loadHtml:self.html];
    }
    else if (self.url) {
        NSString* abs=[self.url absoluteString];
        
        NSMutableDictionary* params=[NSMutableDictionary dictionary];
        
        [params setValue:[NSNumber numberWithInteger:self.idd] forKey:@"id"];
        if (self.type.length>0) {
            [params setValue:self.type forKey:@"type"];
        }
        [params setValue:@"ios" forKey:@"sys"];
        [params setValue:[NSNumber numberWithInteger:[[NSDate date]timeIntervalSince1970]] forKey:@"time"];
        NSString* access_token=[[UserModel getUser]access_token];
        if (access_token.length>0) {
            [params setValue:access_token forKey:@"access_token"];
        }
        
        NSArray* keys=[params allKeys];
        NSMutableArray* keysAndValues=[NSMutableArray array];
        for (NSString* key in keys) {
            NSString* value=[params valueForKey:key];
            
            NSString* kv=[NSString stringWithFormat:@"%@=%@",key,value];
            [keysAndValues addObject:kv];
        }
        
        NSString* body=[keysAndValues componentsJoinedByString:@"&"];
        
        if (body.length>0) {
            if ([abs containsString:[ZZUrlTool main]])
            {
                abs=[NSString stringWithFormat:@"%@%@%@",abs,[abs containsString:@"?"]?@"":@"?",body];
            }
        }
        self.url=[NSURL URLWithString:abs];
        
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hhh.html"];
        
        NSError* err=nil;
        NSString* mTxt=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
        [self.ios8WebView loadHTMLString:mTxt baseURL:nil];
        
        NSLog(@"webview:  %@",abs);
        NSURLRequest* req=[NSURLRequest requestWithURL:self.url];
        
        [self.ios8WebView performSelector:@selector(loadRequest:) withObject:req afterDelay:0.5];
        
        [loadingIndicator removeFromSuperview];
        [self.view addSubview:loadingIndicator];
        [loadingIndicator startAnimating];
        
    }
    
//    UIBarButtonItem* x=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"x"] style:UIBarButtonItemStylePlain target:self action:@selector(closeWebView)];
//    UIBarButtonItem* ba=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popOrBack)];
//    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:ba,x, nil];
}

//-(void)closeWebView
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//-(void)popOrBack
//{
//    if ([self.ios8WebView canGoBack]) {
//        [self.ios8WebView goBack];
//        return;
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)loadHtml:(NSString*)htmlString
{
    [self.ios8WebView loadHTMLString:htmlString baseURL:self.url];

}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
////    self.webUIView.frame=self.view.bounds;
//}

#pragma mark --old uiwebview delegate

//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSLog(@"%@",request);
//    NSString* url=request.URL.absoluteString;
//    if ([url isEqualToString:@"action://scancode"]) {
//        WebScanCodeViewController* we=[[WebScanCodeViewController alloc]init];
//        we.delegate=self;
//        [self.navigationController pushViewController:we animated:YES];
////        [self codeScanerOnResult:@"aaaa"];
//        return NO;
//    }
//    if ([url isEqualToString:@"action://asktologin"])
//    {
//        if ([[[UserModel getUser]access_token]length]>0)
//        {
//            return NO;
//        }
//        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"需要登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            PersonalLoginViewController* lo=[[UIStoryboard storyboardWithName:@"Personal" bundle:nil]instantiateViewControllerWithIdentifier:@"PersonalLoginViewController"];
//            lo.delegate=self;
//            [self.navigationController pushViewController:lo animated:YES];
//        }]];
//
//        [self presentViewController:alert animated:YES completion:nil];
//
//        return NO;
//    }
//    return YES;
//}
//
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadingIndicator startAnimating];
}
//
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.ios8WebView.hidden=NO;
    [loadingIndicator stopAnimating];

    NSString* netitle = [self.ios8WebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (netitle.length>0) {
        self.title=netitle;
    }

//    NSLog(@"%@",[self.ios8WebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"]);
}
//
////-(BOOL)navigationShouldPopOnBackButton
////{
////    if (self.ios8WebView.canGoBack) {
////        [self.ios8WebView goBack];
////        return NO;
////    }
////    return YES;
////}
//
//-(void)codeScanerOnResult:(NSString *)result
//{
//    NSString* js=[NSString stringWithFormat:@"onmarked('%@');",result];
//    [self.ios8WebView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:js afterDelay:0.1];
//}
//
//-(void)personalLoginViewControllerDidLoginToken:(NSString *)token
//{
//    //我想要你在giftlist那里判断没有token的时候，发出action://asktologin，然后由我来弹出对话框去登录，登录之后我在执行你的didlogin(token)函数。
//    NSString* js=[NSString stringWithFormat:@"didlogin('%@');",token];
//    [self.ios8WebView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:js afterDelay:0.1];
//}

@end