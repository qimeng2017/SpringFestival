//
//  ScrollLineView.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "ScrollLineView.h"
#import "StockModel.h"
#import "stockView.h"

@interface ScrollLineView ()
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) stockView * plotView;
@end
@implementation ScrollLineView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupKLinePlotView];
    }
    return self;
}
- (void)setupKLinePlotView
{
    _dataArray = [[NSMutableArray alloc] init];
    //_notShowDataArray = [NSMutableArray arrayWithCapacity:10];
    
    _plotView = [[stockView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.frame.size.height)];
    _plotView.maxNum = 500.0;
    _plotView.minNum = 0.0;
    //_plotView.dataArray = _dataArray;
    [self addSubview:_plotView];
    
    
}
- (void)reloadScrollViewWithDays:(NSArray *)days{
    if (_dataArray.count > 0) {
        [_dataArray removeAllObjects];
    }
    for (StockModel *model in days) {
       [_dataArray addObject:model];
    }
    self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 7.0 * _dataArray.count, 0);
    _plotView.frame = CGRectMake(0, 0, self.contentSize.width, self.frame.size.height);
    _plotView.maxNum = 20.0;
    _plotView.minNum = 0.0;
     [self setContentOffset:CGPointMake(0, 0) animated:YES];
    [_plotView reloadLineViewWithDataArray:_dataArray];
    [self setNeedsDisplay];
}
- (void)reloadScrollViewWithDays: (NSInteger)days notShowDays: (NSInteger)notShowDays {
    
    if (_dataArray.count > 0) {
        [_dataArray removeAllObjects];
    }
    for (NSInteger i = 0; i < days; i++) {
        StockModel * model = [[StockModel alloc] init];
        
        NSString *dateStr = [NSString stringWithFormat:@"%ld",(long)i];
        model.date = dateStr;
        model.profit = [NSString stringWithFormat:@"%.2f", (float)arc4random_uniform(500)];
        [_dataArray addObject:model];
    }
    
    
    self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 7.0 * _dataArray.count, 0);
    
    _plotView.maxNum = 500.0;
    _plotView.minNum = 0.0;
    //[_plotView reloadDoubleLineViewWithDataArray:_dataArray notShowDataArray:_notShowDataArray];
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)drawRect:(CGRect)rect{
    if (!_dataArray || _dataArray.count == 0) {
        return;
    }
    
    CGFloat top = 10;
    CGFloat bottom = 60;
    CGFloat eachWidth = self.frame.size.width / 7.0; // 一屏显示7天
    
    CGFloat startY = self.frame.size.height- bottom;
    
    
    CGFloat x = 10;
    
    
    CGFloat h = self.frame.size.height - top -bottom;
    CGFloat eachHeight=  h / 20;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //开始画坐标轴
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    //直线宽度
    
    CGContextSetLineWidth(context,1.0);
    
    //设置颜色
    
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
    
    //开始绘制
    
    CGContextBeginPath(context);
    
    //左下角点
    CGContextMoveToPoint(context, x, top);
    
    //右下角点
    CGContextAddLineToPoint(context, x, startY);
    //右上角点
    
    
    
    
    //绘制完成
    
    CGContextStrokePath(context);
    
    
    for (int j=0 ; j<=20; j=j+2) {
        NSString *avgStr = [NSString stringWithFormat:@"%d",j];
        
        [avgStr drawInRect:CGRectMake(x+5, h-j*eachHeight, 40, 20) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:[UIColor redColor]}];
    }
    //画线X轴
    CGContextMoveToPoint(context,  x, startY);
    CGContextAddLineToPoint(context, x + (_dataArray.count - 1) * eachWidth, startY);
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
    CGContextSetLineWidth(context, 1);
    CGContextStrokePath(context);
}


@end
