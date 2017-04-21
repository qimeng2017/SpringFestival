//
//  RoadMapTableView.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "RoadMapTableView.h"
#import "RoadMapModel.h"
#import "RoadMapCell.h"
static NSString *RoadMapCellReuseIdentifier = @"RoadMapCellReuseIdentifier";
@interface RoadMapTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *RoadMapArray;
@end
@implementation RoadMapTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.backgroundColor = [UIColor whiteColor];
        self.tableFooterView = [[UIView alloc]init];
        //[self registerClass:[UITableViewCell class] forCellReuseIdentifier:RoadMapCellReuseIdentifier];
    }
    return self;
}
- (void)reloadScrollViewWithDays:(NSArray *)items{
    _RoadMapArray = items;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
   
}
#pragma mark - tableView的数据源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _RoadMapArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    RoadMapCell *cell = [tableView dequeueReusableCellWithIdentifier:RoadMapCellReuseIdentifier];
    if (cell==nil) {
        cell = [[RoadMapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RoadMapCellReuseIdentifier];
    }
    if (_RoadMapArray.count > indexPath.row) {
        RoadMapModel *model = [_RoadMapArray objectAtIndex:indexPath.row];
        [cell roadMapModel:model];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
   
    return cell;
}

@end
