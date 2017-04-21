//
//  TriolionNewCenterView.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "TriolionNewCenterView.h"
#define functionH 60
#define functionW kScreenWidth/4
@interface FunctionTrionlionView : UIView

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *functionLable;
+(instancetype)initWithImageName:(NSString *)imageName functionName:(NSString *)functionName;
@end

@implementation FunctionTrionlionView
+(instancetype)initWithImageName:(NSString *)imageName functionName:(NSString *)functionName{
    FunctionTrionlionView *functionView = [[FunctionTrionlionView alloc]initWithImageName:imageName functionName:functionName];
    return functionView;
}
- (instancetype)initWithImageName:(NSString *)imageName functionName:(NSString *)functionName{
    if (self = [super init]) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:_imageView];
        _functionLable = [[UILabel alloc]init];
        _functionLable.text = functionName;
        _functionLable.font = [UIFont systemFontOfSize:HXTitleSize];
        _functionLable.textColor = [UIColor blackColor];
        [_functionLable sizeToFit];
        [self addSubview:_functionLable];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).with.offset(0);
    }];
    [_functionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_imageView.mas_bottom).with.offset(HXIcoAndTitleSpace);
    }];
}

@end

@interface TriolionNewCenterView ()


@end
@implementation TriolionNewCenterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *shareAry = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qiu" ofType:@"plist"]];
        [self initShareAry:shareAry];
    }
    return self;
}
- (void)initShareAry:(NSArray *)shareAry{
    
    //先移除之前的View
    if (self.subviews.count > 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (NSInteger i = 0; i < shareAry.count; i++) {
        NSDictionary *dict = [shareAry objectAtIndex:i];
        NSString *imageName = [dict objectForKey:@"image"];
        NSString *title = [dict objectForKey:@"title"];
        FunctionTrionlionView *shareView = [FunctionTrionlionView initWithImageName:imageName functionName:title];
        UITapGestureRecognizer *tapFun = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFunction:)];
        [shareView addGestureRecognizer:tapFun];
        shareView.tag = 1000+i;
        [self addSubview:shareView];
    }
    
    [self layoutIfNeeded];
}
- (void)layoutSubviews{
    [super layoutSubviews];
   
    if (self.subviews.count > 0) {
        for (NSInteger i = 0; i<self.subviews.count; i++) {
            NSInteger index = i % 4;
            NSInteger page = i / 4;
            UIView *view = [self viewWithTag:1000+i];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).with.offset(functionW*index);
                make.top.mas_equalTo(self.mas_top).with.offset(HXOriginTop+page*(boderView_H+viewSpace));
                make.size.mas_equalTo(CGSizeMake(functionW, boderView_H));
            }];
        }
        
    }
}
+(CGFloat)getHeight{
    return boderView_H*2+viewSpace+HXOriginTop*2;
}

- (void)tapFunction:(UITapGestureRecognizer *)tap{
    FunctionTrionlionView *functionView = (FunctionTrionlionView *)tap.view;
    NSInteger didIndex = functionView.tag - 1000;
    if (_delegate&&[_delegate respondsToSelector:@selector(clickLottory:)]) {
        [_delegate clickLottory:didIndex];
    }
}
@end
