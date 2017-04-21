//
//  RoadmapViewController.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "RoadmapViewController.h"
#import "RadioSelectView.h"
#import "RoadMapScrollView.h"
#import "UserStore.h"
#import "RoadMapModel.h"
#import <SVProgressHUD.h>
@interface RoadmapViewController ()
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *roadMapArray;
@property (nonatomic, strong) RoadMapScrollView *roadMapScrollView;
@end

@implementation RoadmapViewController
- (NSMutableArray *)roadMapArray{
    if (_roadMapArray == nil) {
        _roadMapArray = [NSMutableArray array];
    }
    return _roadMapArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"路珠分析";
    RadioSelectView *radioView  = [[RadioSelectView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1) itles:nil clickBlick:^(NSInteger index) {
        if (self.roadMapArray.count > 0) {
            [_roadMapArray removeAllObjects];
        }
        _selectedIndex = index;
        [self getRoadMapData:index];
    }];
    [self.view addSubview:radioView];
    _roadMapScrollView = [[RoadMapScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(radioView.frame), kScreenWidth, CGRectGetHeight(self.view.frame)-CGRectGetHeight(radioView.frame))];
    [self.view addSubview:_roadMapScrollView];

}
- (void)getRoadMapData:(NSInteger)index{
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UserStore sharedInstance]getRoadBeadAnalysis:index SucessBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *itemArray = [responseObject objectForKey:@"itemArray"];
        for (NSDictionary *dict in itemArray) {
            RoadMapModel *model = [[RoadMapModel alloc]initWithDictionary:dict error:nil];
            [self.roadMapArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_roadMapArray.count > 0) {
                [_roadMapScrollView reloadScrollViewWithDays:_roadMapArray];
            }
            [SVProgressHUD dismissWithDelay:1];
        });
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
