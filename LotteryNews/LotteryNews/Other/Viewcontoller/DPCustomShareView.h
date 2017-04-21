//
//  DPCustomShareView.h
//  com.demo.DP.ZZ
//
//  Created by 邹壮壮 on 2017/3/31.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#define headerLable_h 44.0 //
#define HXOriginY 15.0 //ico起点Y坐标
#define HXOriginX 20.0
#define HXIcoAndTitleSpace 10.0 //图标和标题间的间隔
#define boderView_H  100

#define HXTitleSize 12.0 //标签字体大小
#define HXTitleColor [UIColor colorWithRed:52/255.0 green:52/255.0 blue:50/255.0 alpha:1.0] //标签字体颜色
#define HXHorizontalSpace 10.0 //间距
#define fottorCancleH 44.0

@class DPCustomShareView;
@protocol DPCustomShareViewDelegate <NSObject>

- (void)easyCustomShareViewButtonAction:(DPCustomShareView *)shareView title:(NSString *)title selectedIndex:(NSInteger)selectedIndex;

@end
@interface DPCustomShareView : UIView
@property (nonatomic,assign) id<DPCustomShareViewDelegate> delegate;
@property (nonatomic,strong) UIView *backView;//背景View
@property (nonatomic,strong) UILabel *headerLable;//头部分享标题
@property (nonatomic,strong) UILabel *middleLineLabel1;//中间线
@property (nonatomic,strong) UIView *boderView;//中间View,主要放分享
@property (nonatomic,strong) UILabel *middleLineLabel2;//中间线

@property (nonatomic,strong) UIButton *footerButton;//取消
- (void)setShareAry:(NSArray *)shareAry;
- (void)showShareView;
@end
