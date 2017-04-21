//
//  stockView.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//
#define TextFontWithSize(a) [UIFont systemFontOfSize:(a)]
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define rgb(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define beginColor  [UIColor colorWithHexString:@"#f36468"]
#define endColor  [UIColor colorWithHexString:@"#f36468"]

#define KBottom_H       60.0
#define KTop_H          10.0
#define KCircle_Radius  3.0
#define KTextBorder     1.0
#define KPointBorder    5.0
#define KBorder         15.0
#import "stockView.h"
#import "StockModel.h"
CGFloat distanceBetweenPoint(CGPoint beginP, CGPoint endP) {
    
    CGFloat xDistance = beginP.x - endP.x;
    CGFloat yDistance = beginP.y - endP.y;
    
    return sqrt(xDistance * xDistance + yDistance * yDistance);
}

@interface stockView ()
@property (nonatomic, strong) NSMutableArray * pointsArray;

@end
@implementation stockView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _pointsArray = [NSMutableArray arrayWithCapacity:10];
        _minNum = 0;
       

    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _pointsArray = [NSMutableArray arrayWithCapacity:10];
        _minNum = 0;
        
    }
    
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
}

// 重新绘制双折线图
- (void)reloadDoubleLineViewWithDataArray:(NSArray *)daatArray
                         notShowDataArray:(NSArray *)notDataArray
{
    _dataArray = daatArray;
    _notShowDataArray = notDataArray;
    
    [self setNeedsDisplay];
}

// 重新绘制折线图
- (void)reloadLineViewWithDataArray:(NSArray *)daatArray
{
    _dataArray = daatArray;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (!_dataArray && _dataArray.count == 0) {
        return;
    }
    
    // 初始化
    // 计算每段的width
    CGFloat eachWidth = kScreenWidth / 7.0; // 一屏显示7天
    CGFloat startX = eachWidth * 0.5;
    CGFloat startY = self.frame.size.height - KBottom_H;
    CGFloat kLineHeight = startY - KTop_H;
    // 每段比例高度
    CGFloat eachHeight = 0.0;
    
    if (_maxNum == _minNum) {
        eachHeight = 0.0;
    }else {
        eachHeight = kLineHeight / (_maxNum - _minNum);
    }
    
    // 获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画线X轴
    //    CGContextMoveToPoint(ctx,  startX, startY);
    //    CGContextAddLineToPoint(ctx, startX + (_dataArray.count - 1) * eachWidth, startY);
    //    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0xcccccc).CGColor);
    //    CGContextSetLineWidth(ctx, 0.5);
    //    CGContextStrokePath(ctx);
    // 画y轴标注
    for (int i = 0; i < _dataArray.count; i++) {
        StockModel * model = _dataArray[i];
        NSString * text = model.date;
        NSDictionary * attributes = @{NSFontAttributeName : TextFontWithSize(9.0), NSForegroundColorAttributeName : [UIColor whiteColor]};
        CGSize textSize = [text sizeWithAttributes:attributes];
        CGFloat textX = startX + i * eachWidth - textSize.width * 0.5;
        CGFloat textY = startY + KBottom_H/2 - textSize.height;
        
        [text drawInRect:CGRectMake(textX, textY, textSize.width, textSize.height) withAttributes:attributes];
    }
    
    // 画y轴线
    for (int i = 0; i < _dataArray.count; i++) {
        CGContextMoveToPoint(ctx, startX + i* eachWidth, startY);
        CGContextAddLineToPoint(ctx, startX + i* eachWidth, KTop_H);
    }
    
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0xcccccc).CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextStrokePath(ctx);
    
    
    
#pragma mark - 绘制红色的线
    
//    if (_dataArray.count == 7) {
//        _colorsArray = Week_dayColors;
//    }else if (_dataArray.count == 30) {
//        _colorsArray = Month_dayColors;
//    }else if (_dataArray.count == 90) {
//        _colorsArray = ThreeMonth_dayColors;
//    }
    
    if (_pointsArray.count > 0) {
        [_pointsArray removeAllObjects];
    }
    
    // 记录画线的坐标点的值
    for (int i = 0; i < _dataArray.count; i++) {
        StockModel * model = _dataArray[i];
        double num = [model.profit doubleValue];
        CGFloat circleX = startX + (i ) * eachWidth;
        CGFloat circleY = 0.0;
        if (_maxNum == _minNum) {
            circleY = startY - eachHeight;
        }else {
            circleY = startY - (num - _minNum) * eachHeight;
        }
        
        CGPoint point = CGPointMake(circleX, circleY);
        NSValue * value = [NSValue valueWithCGPoint:point];
        [_pointsArray addObject:value];
    }
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    CGPoint beginPoint;
    CGPoint endPoint;
    
    CGPoint startPt = [_pointsArray[0] CGPointValue];
    CGFloat circleX = startPt.x;
    CGFloat circleY = startPt.y;
    
    CGContextMoveToPoint(ctx, circleX, circleY);
    for (int i = 0; i < _pointsArray.count-1; i++) {
       
       
            
            // begin to end
            beginPoint = [_pointsArray[i] CGPointValue];
            endPoint = [_pointsArray[i+1] CGPointValue];
            
            NSArray * array = @[(__bridge id)beginColor.CGColor, (__bridge id)endColor.CGColor];
            CGGradientRef gradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)array, NULL);
            CGColorSpaceRelease(rgb);
            
            CGContextSaveGState(ctx);
            
            CGFloat increateY = fabs(endPoint.x - beginPoint.x) / distanceBetweenPoint(beginPoint, endPoint) * 1.0;
            CGFloat increateX = fabs(endPoint.y - beginPoint.y) / distanceBetweenPoint(beginPoint, endPoint) * 1.0;
            
            if (endPoint.y > beginPoint.y) {
                CGContextMoveToPoint(ctx, beginPoint.x - increateX, beginPoint.y + increateY);
                CGContextAddLineToPoint(ctx, beginPoint.x + increateX, beginPoint.y - increateY);
                CGContextAddLineToPoint(ctx, endPoint.x + increateX, endPoint.y - increateY);
                CGContextAddLineToPoint(ctx, endPoint.x - increateX, endPoint.y + increateY);
            }
            else {
                CGContextMoveToPoint(ctx, beginPoint.x - increateX, beginPoint.y - increateY);
                CGContextAddLineToPoint(ctx, beginPoint.x + increateX, beginPoint.y + increateY);
                CGContextAddLineToPoint(ctx, endPoint.x + increateX, endPoint.y + increateY);
                CGContextAddLineToPoint(ctx, endPoint.x - increateX, endPoint.y - increateY);
            }
            
            CGContextClip(ctx);
            CGContextDrawLinearGradient(ctx, gradient,beginPoint ,endPoint,
                                        kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(ctx); // 恢复到之前的context
        
    }
    // 释放colorSpace
    CGColorSpaceRelease(rgb);
    
    
    // 渐变圈
    for (int i = 0; i < _dataArray.count; i++) {
        StockModel * model = _dataArray[i];
        double num = [model.profit doubleValue];
        if (num != -9999) {
            CGFloat circleX = startX + (i) * eachWidth;
            CGFloat circleY = 0.0;
            if (_maxNum == _minNum) {
                circleY = startY - eachHeight;
            }else {
                circleY = startY - (num - _minNum) * eachHeight;
            }
            
            // 小圆
            CGContextAddArc(ctx, circleX, circleY, KCircle_Radius, 0, M_PI * 2, 0);
            CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0xffffff).CGColor);
            CGContextDrawPath(ctx, kCGPathEOFill);
            // 大圆
            UIColor * circle_color = UIColorFromRGB(0xff4949);
            
            
            CGContextAddArc(ctx, circleX, circleY, KCircle_Radius, 0, M_PI * 2, 0);
            CGContextSetStrokeColorWithColor(ctx, circle_color.CGColor);
            CGContextSetLineWidth(ctx, 2.0);
            CGContextStrokePath(ctx);
        }
    }
    
    // 画胶囊
    // 左半圆
    NSDictionary * attributes = @{NSFontAttributeName : TextFontWithSize(9.0), NSForegroundColorAttributeName : UIColorFromRGB(0xffffff)};
    for (int i = 0; i < _dataArray.count; i++) {
        StockModel * model = _dataArray[i];
        double num = [model.profit doubleValue];
        
        if (num != -9999) {
            CGFloat circleX = startX + (i) * eachWidth;
            CGFloat circleY = 0.0;
            if (_maxNum == _minNum) {
                circleY = startY - eachHeight;
            }else {
                circleY = startY - (num - _minNum) * eachHeight;
            }
            
            NSString * numStr = [NSString stringWithFormat:@"%.2lf", num];
            
            CGSize numSize = [numStr sizeWithAttributes:attributes];
            CGFloat radius = (numSize.height + KTextBorder * 2.0) * 0.5;
            CGFloat numX = circleX - numSize.width * 0.5;
            CGFloat numY = 0.0;
            
            // 取出上一个点的数据和这个点的数据
            double preNum = 0.0;
            if (i > 0) {
                StockModel * model = _dataArray[i-1];
                preNum = [model.profit doubleValue];
            }
            
            // 第一个点和上升的点在上面
            if ((num - preNum) >= 0.0) {
                // 在圆点上面
                numY = circleY - KCircle_Radius - KPointBorder - radius;
                
                // 判断第一个点的走势
                if (self.dataArray.count > 2 && i == 0) {
                    StockModel * nextModel = self.dataArray[i+1];
                    double nextNum = [nextModel.profit doubleValue];
                    if (nextNum > num) {
                        // 在圆点下面
                        numY = circleY + KCircle_Radius + KPointBorder + radius;
                    }else {
                        // 在圆点上面
                        numY = circleY - KCircle_Radius - KPointBorder - radius;
                    }
                }
            }else {
                // 在圆点下面
                numY = circleY + KCircle_Radius + KPointBorder + radius;
            }
            
            CGContextAddArc(ctx, numX, numY, radius, M_PI_2, M_PI_2 * 3, 0);
            CGContextAddLineToPoint(ctx, numX, numY);
            // 右半圆
            CGContextAddArc(ctx, numX + numSize.width, numY, radius, M_PI_2, -M_PI_2, 1);
            CGContextAddLineToPoint(ctx, numX + numSize.width, numY + radius);
            
            // 画矩形
            CGContextMoveToPoint(ctx, numX, numY - radius);
            CGContextAddLineToPoint(ctx, numX + numSize.width, numY - radius);
            CGContextAddLineToPoint(ctx, numX + numSize.width, numY + radius);
            CGContextAddLineToPoint(ctx, numX, numY + radius);
            CGContextAddLineToPoint(ctx, numX, numY - radius);
            
            UIColor * circle_color = UIColorFromRGB(0xff4949);
           
            
            CGContextSetFillColorWithColor(ctx, circle_color.CGColor);
            CGContextFillPath(ctx);
            
            // 画文字（此处可以调整字的位置）
            [numStr drawInRect:CGRectMake(numX, numY - numSize.height * 0.5 - 0.5, numSize.width, numSize.height) withAttributes:attributes];
        }
    }
}


@end
