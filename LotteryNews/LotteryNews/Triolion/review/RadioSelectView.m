//
//  RadioSelectView.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "RadioSelectView.h"
#define Start_X 20.0f*kScaleW           // 第一个按钮的X坐标
#define Start_Y 10.0f*kScaleW           // 第一个按钮的Y坐标
#define Width_Space 5.0f*kScaleW        // 2个按钮之间的横间距
#define Height_Space 5.0f*kScaleW      // 竖间距
#define Button_Height  30*kScaleW   // 高
#define Button_Width (kScreenWidth - Start_X*2 - Width_Space*3)/4      // 宽


@interface RadioSelectView ()
@property (nonatomic,strong) NSMutableArray *btns;
@property (nonatomic,strong) UIButton *titleBtn;
@end
@implementation RadioSelectView
-(instancetype)initWithFrame:(CGRect)frame itles:(NSArray *)titleArray  clickBlick:(btnClickBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultIndex=0;
        _btns=[[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i=0; i<roadMapBtnList.count; i++) {
            NSInteger index = i % 4;
            NSInteger page = i / 4;
            NSString *title = roadMapBtnList[i];
            // 圆角按钮
            UIButton *aBt = [UIButton buttonWithType:UIButtonTypeCustom];
            aBt.tag = i;
            aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
            
            aBt.titleLabel.font = [UIFont systemFontOfSize:18];
            [aBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [aBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [aBt setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
            [aBt setTitle:title forState:UIControlStateNormal];
            [aBt addTarget:self action:@selector(abtAction:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:aBt];
            [_btns addObject:aBt];
            self.block=block;
            if (i==0) {
                _titleBtn=aBt;
                aBt.selected=YES;
                [aBt setBackgroundColor:[UIColor colorWithHexString:@"#ec6464"]];
                if (self.block) {
                    self.block(0);
                }
            }
        }
        CGFloat height = 2*Button_Height+Height_Space+2*Start_Y;
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height);
    }
    return self;
}

- (void)abtAction:(UIButton *)btn{
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#ec6464"]];
    if (self.block) {
        self.block(btn.tag);
    }
    
    if (btn.tag==_defaultIndex) {
        return;
    }else{
        _titleBtn.selected=!_titleBtn.selected;
        [_titleBtn setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
        _titleBtn=btn;
        _titleBtn.selected=YES;
        _defaultIndex=btn.tag;
    }
}
@end
