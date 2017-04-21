//
//  RoadMapScrollView.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "RoadMapScrollView.h"
#import "RoadMapTableView.h"
#import "RoadMapModel.h"
@interface RoadMapScrollView ()
@property (nonatomic, strong)RoadMapTableView *roadMapTableView;
@end
@implementation RoadMapScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupKLinePlotView];
    }
    return self;
}
- (void)setupKLinePlotView{
    _roadMapTableView = [[RoadMapTableView alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:_roadMapTableView];
}
- (void)reloadScrollViewWithDays:(NSArray *)items{
    RoadMapModel *firstModel = [items firstObject];
    self.contentSize = CGSizeMake(roadBallWidth * firstModel.data.count, 0);
    _roadMapTableView.frame = CGRectMake(0, 0, self.contentSize.width, self.frame.size.height);
    [_roadMapTableView reloadScrollViewWithDays:items];
}
@end
