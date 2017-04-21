//
//  DPCustomShareView.m
//  com.demo.DP.ZZ
//
//  Created by 邹壮壮 on 2017/3/31.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "DPCustomShareView.h"

#define functionH 60
#define functionW kScreenWidth/2
@interface FunctionShareView : UIView

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *functionLable;
+(instancetype)initWithImageName:(NSString *)imageName functionName:(NSString *)functionName;
@end

@implementation FunctionShareView
+(instancetype)initWithImageName:(NSString *)imageName functionName:(NSString *)functionName{
    FunctionShareView *functionView = [[FunctionShareView alloc]initWithImageName:imageName functionName:functionName];
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
@interface DPCustomShareView ()
@property (nonatomic, strong)NSArray *shareArray;
@end
@implementation DPCustomShareView
- (instancetype)init{
    if (self = [super init]) {
        CGRect shareViewFrame = [[UIScreen mainScreen]bounds];
        self.frame = shareViewFrame;
        UIView *zhezhaoView = [[UIView alloc] initWithFrame:shareViewFrame];
        zhezhaoView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        zhezhaoView.tag = 100;
        zhezhaoView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [zhezhaoView addGestureRecognizer:myTap];
        [self addSubview:zhezhaoView];
        //背景
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        _headerLable = [[UILabel alloc]init];
        _headerLable.text = @"分享到";
        _headerLable.textColor = [UIColor blackColor];
        _headerLable.textAlignment = NSTextAlignmentCenter;
        _headerLable.font = [UIFont systemFontOfSize:16];
        [_backView addSubview:_headerLable];
        
        _middleLineLabel1 = [[UILabel alloc]init];
        _middleLineLabel1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
        [_backView addSubview:_middleLineLabel1];
        
        _boderView = [[UIView alloc]init];
        [_backView addSubview:_boderView];
        
        _middleLineLabel2 = [[UILabel alloc]init];
        _middleLineLabel2.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
        [_backView addSubview:_middleLineLabel2];
        
        _footerButton = [[UIButton alloc]init];
        [_footerButton setTitle:@"取消" forState:UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_footerButton];
    }
    return self;
}

- (void)setShareAry:(NSArray *)shareAry{
    _shareArray = shareAry;
    //先移除之前的View
    if (_boderView.subviews.count > 0) {
        [_boderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (NSInteger i = 0; i < _shareArray.count; i++) {
        NSDictionary *dict = [_shareArray objectAtIndex:i];
        NSString *imageName = [dict objectForKey:@"image"];
        NSString *title = [dict objectForKey:@"title"];
        FunctionShareView *shareView = [FunctionShareView initWithImageName:imageName functionName:title];
        UITapGestureRecognizer *tapFun = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFunction:)];
        [shareView addGestureRecognizer:tapFun];
        shareView.tag = 1000+i;
        [_boderView addSubview:shareView];
    }
    [_headerLable sizeToFit];
    [self layoutIfNeeded];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat y = 0;
    _headerLable.frame = CGRectMake(0, y, kScreenWidth, headerLable_h);
    y = CGRectGetHeight(_headerLable.frame);
    _middleLineLabel1.frame = CGRectMake(0, y, kScreenWidth, 0.5);
    y+=0.5;
    if (_boderView.subviews.count > 0) {
        for (NSInteger i = 0; i<_boderView.subviews.count; i++) {
            UIView *view = [_boderView viewWithTag:1000+i];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_boderView.mas_left).with.offset(functionW*i);
                make.top.mas_equalTo(_boderView.mas_top).with.offset(HXOriginY);
                make.size.mas_equalTo(CGSizeMake(functionW, boderView_H-HXOriginY*2));
            }];
        }
        _boderView.frame = CGRectMake(0, y, kScreenWidth, boderView_H);
        y+=boderView_H;
    }
    y+=HXHorizontalSpace;
    _middleLineLabel2.frame = CGRectMake(0, y, kScreenWidth, 0.5);
    y+=0.5;
    _footerButton.frame = CGRectMake(0, y, kScreenWidth, fottorCancleH);
    y+=fottorCancleH;
    _backView.frame = CGRectMake(0, kScreenHeight - y, kScreenWidth, y);
    
}
- (void)tapFunction:(UITapGestureRecognizer *)tap{
    FunctionShareView *shareView = (FunctionShareView *)tap.view;
    NSInteger selected = shareView.tag - 1000;
    if (_delegate &&[_delegate respondsToSelector:@selector(easyCustomShareViewButtonAction:title:selectedIndex:)]) {
        [_delegate easyCustomShareViewButtonAction:self title:shareView.functionLable.text selectedIndex:selected];
    }
    [self dismiss];
}
- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)tap{
    [self dismiss];
}
- (void)cancle{
    [self dismiss];
}
- (void)showShareView{
    if (self.superview != nil) return;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self animationWithAlertView];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
         [self animationWithAlertView];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)animationWithAlertView {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.15;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.backView.layer addAnimation:animation forKey:nil];
}
@end
