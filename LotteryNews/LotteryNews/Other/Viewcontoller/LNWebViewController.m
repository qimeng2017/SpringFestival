//
//  LNWebViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LNWebViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LNActionSheetView.h"
#import "ProgressHUD.h"
#import "DPCustomShareView.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "HRSystem.h"
@interface LNWebViewController () <UIWebViewDelegate,DPCustomShareViewDelegate>

{
    UIWebView *_webView;
    
    //UIActivityIndicatorView     *_indicatorView;
    
}

@property (nonatomic, strong) NSURL *aUrl;

@end

@implementation LNWebViewController
@synthesize aUrl;
- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        self.aUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        // Do any additional setup after loading the view.
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        [self.view addSubview:webView];
        _webView = webView;
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        
        
       
    }
    if (_fromTrion) {
        UIButton *frendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        frendsBtn.frame = CGRectMake(0, 0, 25, 25);
        [frendsBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [frendsBtn addTarget:self action:@selector(openShareView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:frendsBtn];
    }
    
    if (_isPreset) {
        UIView *cancaleView = [[UIView alloc]init];
        UITapGestureRecognizer *cancleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
        [cancaleView addGestureRecognizer:cancleTap];
        [self.view addSubview:cancaleView];
        
        UIImageView *cancaleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"关闭"]];
        [cancaleView addSubview:cancaleImageView];
        [cancaleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).with.offset(30);
            make.left.mas_equalTo(self.view.mas_left).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [cancaleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cancaleView.mas_top).with.offset(0);
            make.left.mas_equalTo(cancaleView.mas_left).with.offset(0);
        }];
        
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD showWithStatus:@"Loading..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.aUrl];
     [_webView loadRequest:request];
    
}

- (void)back
{
    _webView.delegate = nil;
    [_webView stopLoading];
    
    if (self.presentingViewController.presentedViewController == self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goBack
{
    [_webView stopLoading];
    [_webView goBack];
}

#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[_indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
   // [_indicatorView stopAnimating];
    //添加图片可点击js
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];

    
   
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        for (NSInteger index = 0; index < self.imageArr.count; index++) {
//            NSString *url = self.imageArr[index];
//            if ([url isEqualToString:path]) {
//                [self selectedIndex:index];
//            }
//        }
        [self sheet:path];
        return NO;
    }
    return YES;
}
- (void)sheet:(NSString *)path{
  
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    UIImage *image = [UIImage imageWithData:imageData];
    [LNActionSheetView showWithTitle:nil destructiveTitle:nil otherTitles:@[@"保存图片"] block:^(int index) {
        if (index == 0) {
            if ([self isPhotoLibraryAvailable]) {
               UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
            
        }
    }];
}
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [[ProgressHUD sharedInstance]showErrorOrSucessWithStatus:NO message:@"保存成功"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //[_indicatorView stopAnimating];
}


#pragma mark-- 分享
- (void)openShareView{
    NSArray *shareAry = @[@{@"image":@"shareView_wx",
                            @"title":@"微信"},
                          @{@"image":@"shareView_friend",
                            @"title":@"朋友圈"}
                          ];
    DPCustomShareView *shareView = [[DPCustomShareView alloc]init];
    shareView.delegate = self;
    [shareView setShareAry:shareAry];
    [shareView showShareView];
    
}
- (void)easyCustomShareViewButtonAction:(DPCustomShareView *)shareView title:(NSString *)title selectedIndex:(NSInteger)selectedIndex{
    NSLog(@"%@",title);
    switch (selectedIndex) {
        case 0:
            [self shareFriends];
            break;
        case 1:
            [self shareCircleOfFriends];
            break;
        case 2:

        default:
            break;
    }
}
- (void)shareFriends{
    
    NSString *url = [NSString stringWithFormat:@"%@",self.aUrl];
    [WXApiRequestHandler sendLinkURL:url TagName:nil Title:_triolionTitle Description:_triolionDescription ThumbImage:nil InScene:WXSceneSession];
    
}
- (void)shareCircleOfFriends{
    NSString *url = [NSString stringWithFormat:@"%@",self.aUrl];
    [WXApiRequestHandler sendLinkURL:url TagName:nil Title:_triolionTitle Description:_triolionDescription ThumbImage:nil InScene:WXSceneTimeline];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
