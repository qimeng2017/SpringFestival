//
//  RadioSelectView.h
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^btnClickBlock)(NSInteger index);
@interface RadioSelectView : UIView
-(instancetype)initWithFrame:(CGRect)frame itles:(NSArray *)titleArray  clickBlick:(btnClickBlock)block;
@property (nonatomic,copy)btnClickBlock block;
@property (nonatomic,assign) NSInteger defaultIndex;
@end
