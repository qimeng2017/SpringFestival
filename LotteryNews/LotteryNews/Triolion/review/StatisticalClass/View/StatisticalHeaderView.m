//
//  StatisticalHeaderView.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/16.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "StatisticalHeaderView.h"

#define self_width self.frame.size.width
#define self_height self.frame.size.height
#define dateLableWidth 63.5
@interface StatisticalHeaderView ()
@property (nonatomic ,strong) UIView *longDrageView;
@property (nonatomic, strong) UIScrollView *numberDayStatView;
@property (nonatomic, strong) UIScrollView *twoStatView;
@end
@implementation StatisticalHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    _longDrageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self_width, self_height)];
    [self addSubview:_longDrageView];
    _longDrageView.hidden = YES;
    NSArray *longDrageArray = @[@"类型",@"两面类别",@"已开日期"];
    CGFloat longDrageLableWidth = self_width/3;
    for (NSInteger i=0; i<longDrageArray.count; i++) {
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(longDrageLableWidth*i, 0, longDrageLableWidth, self_height)];
        lable.textColor = [UIColor blackColor];
        lable.text = [longDrageArray objectAtIndex:i];
        lable.font = [UIFont systemFontOfSize:16];
        lable.textAlignment = NSTextAlignmentCenter;
        [_longDrageView addSubview:lable];
    }
    _numberDayStatView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self_width, self_height)];
    _numberDayStatView.showsVerticalScrollIndicator = NO;
    _numberDayStatView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_numberDayStatView];
    _numberDayStatView.hidden = YES;
    NSArray *numberarray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19"];
    [self scroll:_numberDayStatView nums:numberarray];
    
    _twoStatView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self_width, self_height)];
    _twoStatView.showsVerticalScrollIndicator = NO;
    _twoStatView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_twoStatView];
    _twoStatView.hidden = YES;
    NSArray *twoArray = @[@"大",@"小",@"单",@"双",@"龙",@"虎"];
    [self scroll:_twoStatView nums:twoArray];
    
    
   
    
    
}
- (void)scroll:(UIScrollView *)scrollView nums:(NSArray *)nums{
    CGFloat x = dateLableWidth+8;
    UILabel *dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, dateLableWidth, self_height)];
    dateLable.text = @"日期";
    dateLable.textColor = [UIColor blackColor];
    dateLable.font = [UIFont systemFontOfSize:14];
    dateLable.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:dateLable];
    
    NSUInteger count = nums.count;
    
    UIImage *ballImage = [UIImage imageNamed:@"ball_blue"];
    CGFloat contentWidth =  count*ballImage.size.width+(count-1)*10;
    if (CGRectGetWidth(scrollView.frame)- dateLableWidth>contentWidth) {
        x = (CGRectGetWidth(scrollView.frame)-dateLableWidth-contentWidth)/2+dateLableWidth;
    }
    scrollView.contentSize = CGSizeMake(contentWidth+dateLableWidth, 0);
    for (NSInteger index = 0; index < [nums count]; index ++) {
        
        UIButton *ballBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_blue"] forState:UIControlStateNormal];
        ballBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [ballBtn setTitle:[nums objectAtIndex:index] forState:UIControlStateNormal];
        [ballBtn sizeToFit];
        ballBtn.frame = CGRectMake(x, (CGRectGetHeight(scrollView.frame)- CGRectGetHeight(ballBtn.frame))/2, CGRectGetWidth(ballBtn.frame), CGRectGetHeight(ballBtn.frame));
        
        x += CGRectGetWidth(ballBtn.frame) + 10;
        
        [scrollView addSubview:ballBtn];
        
    }
    
}
- (void)index:(NSInteger)index{
    if (index == 0) {
        _longDrageView.hidden = NO;
        _twoStatView.hidden = YES;
        _numberDayStatView.hidden = YES;
    }else if (index==1){
        _longDrageView.hidden = YES;
        _twoStatView.hidden = YES;
        _numberDayStatView.hidden = NO;
    }else{
        _longDrageView.hidden = YES;
        _twoStatView.hidden = NO;
        _numberDayStatView.hidden = YES;
    }
}

@end
