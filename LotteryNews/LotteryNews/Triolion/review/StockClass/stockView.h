//
//  stockView.h
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface stockView : UIView
@property (nonatomic, assign) CGFloat maxNum; // K线y轴上的最大值
@property (nonatomic, assign) CGFloat minNum; // 最小值

// 数据源
@property (nonatomic, strong) NSArray * dataArray;
// 只显示走势的数据源
@property (nonatomic, strong) NSArray * notShowDataArray;

// 重新绘制
- (void)reloadLineViewWithDataArray:(NSArray *)daatArray;
// 重新绘制双折线图
- (void)reloadDoubleLineViewWithDataArray:(NSArray *)daatArray
                         notShowDataArray:(NSArray *)notDataArray;
@end
