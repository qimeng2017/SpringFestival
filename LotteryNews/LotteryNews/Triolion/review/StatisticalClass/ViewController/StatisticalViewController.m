//
//  StatisticalViewController.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "StatisticalViewController.h"
#import "HRSegmentView.h"
#import "LongDragonCellTableViewCell.h"
#import "NumberdaystatCell.h"
#import "LongDrageModel.h"
#import "numberdaystatModel.h"
#import "UserStore.h"
#import "StatisticalHeaderView.h"
#import <SVProgressHUD.h>
static NSString * const LongDragonCellReuseIdentifier = @"LongDragonCellReuseIdentifier";
static NSString * const NumberdaystatCellReuseIdentifier = @"NumberdaystatCellReuseIdentifier";
@interface StatisticalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *statisticalTableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *statisticalArray;
@property (nonatomic, strong) StatisticalHeaderView *headerView;
@end

@implementation StatisticalViewController
- (NSMutableArray *)statisticalArray{
    if (_statisticalArray == nil) {
        _statisticalArray = [NSMutableArray array];
    }
    return _statisticalArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"统计结果";
    NSArray *aa = @[@"两面长龙",@"号码统计",@"两面统计"];
    HRSegmentView *segmentView = [[HRSegmentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) titles:aa clickBlick:^(NSInteger index) {
        if (self.statisticalArray.count > 0) {
            [_statisticalArray removeAllObjects];
        }
        _selectedIndex = index;
        [self getStatistical:index];
        
    }];
    
    [self.view addSubview:segmentView];
    _headerView = [[StatisticalHeaderView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentView.frame), kScreenWidth, 30)];
    [self.view addSubview:_headerView];
    self.statisticalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, SCREEN_HEIGHT-30-30) style:UITableViewStylePlain];
    _statisticalTableView.delegate = self;
    _statisticalTableView.dataSource = self;
    [self.view addSubview:_statisticalTableView];
    _statisticalTableView.tableFooterView = [[UIView alloc]init];
     [self.statisticalTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LongDragonCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:LongDragonCellReuseIdentifier];
   [self.statisticalTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NumberdaystatCell class]) bundle:nil] forCellReuseIdentifier:NumberdaystatCellReuseIdentifier];
  
}
- (void)getStatistical:(NSInteger)index{
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UserStore sharedInstance]getstatisticalResult:index SucessBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *itemArray = [responseObject objectForKey:@"itemArray"];
        for (NSArray *item in itemArray) {
            if (index == 0) {
                LongDrageModel *model = [[LongDrageModel alloc]init];
                NSString *typeBall = item[0];
                NSArray *ballArr = [typeBall componentsSeparatedByString:@","];
                model.type = ballArr[0];
                model.category = ballArr[1];
                model.openPeriods = item[1];
                [_statisticalArray addObject:model];
            }else if (index == 1){
                numberdaystatModel *model = [[numberdaystatModel alloc]initWith:item];
                [_statisticalArray addObject:model];
            }else if(index == 2){
                numberdaystatModel *model = [[numberdaystatModel alloc]initWith:item];
                [_statisticalArray addObject:model];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statisticalTableView reloadData];
            [_headerView index:index];
            [SVProgressHUD dismissWithDelay:1];
        });
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _statisticalArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex == 0) {
        LongDragonCellTableViewCell *longDragoncell = [tableView dequeueReusableCellWithIdentifier:LongDragonCellReuseIdentifier];
        if (_statisticalArray.count > indexPath.row) {
            LongDrageModel *model = [_statisticalArray objectAtIndex:indexPath.row];
            [longDragoncell setLongDragonModel:model];
        }
        return longDragoncell;
    }else{
        NumberdaystatCell *numberCell = [tableView dequeueReusableCellWithIdentifier:NumberdaystatCellReuseIdentifier];
        if (_statisticalArray.count > indexPath.row) {
            numberdaystatModel *model = [_statisticalArray objectAtIndex:indexPath.row];
            [numberCell setNumberModel:model];
        }
        return numberCell;
    }
    
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
