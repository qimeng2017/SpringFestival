//
//  ScrollKLineViewController.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "ScrollKLineViewController.h"
#import "ScrollLineView.h"
#import "HRSegmentView.h"
#import "UserStore.h"
#import "StockModel.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#define top 40
@interface ScrollKLineViewController ()

@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (strong, nonatomic)ScrollLineView *scrollLineView;
@property (nonatomic, assign) CGRect scrollFrame;
@property (nonatomic ,strong) NSMutableArray *stockArray;
@end

@implementation ScrollKLineViewController
- (NSMutableArray *)stockArray{
    if (_stockArray == nil) {
        _stockArray = [NSMutableArray array];
        
    }
    return _stockArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self toolbarHidden:NO];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 1;
    self.title = @"走势图";
    // app启动或者app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    self.view.backgroundColor = [UIColor blackColor];
    self.originFrame = CGRectMake(0, top, self.view.frame.size.width, self.view.frame.size.height);
    _scrollLineView = [[ScrollLineView alloc]initWithFrame:self.originFrame];
    [self.view addSubview:_scrollLineView];
    self.isFullscreenMode = YES;
    NSArray *ballArray = @[@"第一球",@"第二球",@"第三球",@"第四球",@"第五球",@"第六球",@"第七球",@"第八球"];
    HRSegmentView *segmentView = [[HRSegmentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, top) titles:ballArray clickBlick:^(NSInteger index) {
        [self getNumber:index];
    }];
    [self.view addSubview:segmentView];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)applicationBecomeActive{
    self.isFullscreenMode = YES;
    
}
- (void)getNumber:(NSInteger)ball{
    if (self.stockArray.count > 0) {
        [_stockArray removeAllObjects];
    }
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UserStore sharedInstance]getNumbertrenddata:ball SucessBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *itemArray = [responseObject objectForKey:@"itemArray"];
        for (NSDictionary *dict in itemArray) {
            StockModel *model = [[StockModel alloc]init];
            model.date = [dict objectForKey:@"Key"];
            model.profit = [dict objectForKey:@"Value"];
            [self.stockArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_scrollLineView reloadScrollViewWithDays:self.stockArray];
            [SVProgressHUD dismissWithDelay:1];
        });
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)toolbarHidden:(BOOL)Bool{
    self.navigationController.navigationBar.hidden = Bool;
    self.tabBarController.tabBar.hidden = Bool;
}
#pragma mark 设置是否需要全屏的方法
- (void)setIsFullscreenMode:(BOOL)isFullscreenMode{
    _isFullscreenMode = isFullscreenMode;
    if (isFullscreenMode) {
        CGFloat height = [[UIScreen mainScreen] bounds].size.width;
        CGFloat width = [[UIScreen mainScreen] bounds].size.height;
        CGRect frame = CGRectMake(0, top, width, height-top);
        self.scrollFrame =frame;
        [UIView animateWithDuration:0.5f animations:^{
            [[UIDevice currentDevice] setValue:
             [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
            
        }];
    }else{
        self.scrollFrame = self.originFrame;
        [UIView animateWithDuration:0.5f animations:^{
            [[UIDevice currentDevice] setValue:
             [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
            
        }];
    }
}
- (void)setScrollFrame:(CGRect)scrollFrame
{
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
         [_scrollLineView setFrame:scrollFrame];
        [self.scrollLineView setNeedsLayout];
        [self.scrollLineView layoutIfNeeded];
    });

  
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[[UIDevice currentDevice] setValue:
   //  [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [SVProgressHUD dismiss];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 0;
}
#pragma mark - 屏幕旋转相关方法
#pragma mark 是否支持自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
