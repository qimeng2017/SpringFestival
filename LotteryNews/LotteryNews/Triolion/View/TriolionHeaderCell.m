//
//  TriolionHeaderCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/6.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "TriolionHeaderCell.h"
#define Start_X 20.0f*kScaleW           // 第一个按钮的X坐标
#define Start_Y 10.0f*kScaleW           // 第一个按钮的Y坐标
#define Width_Space 20.0f*kScaleW        // 2个按钮之间的横间距
#define Height_Space 20.0f*kScaleW      // 竖间距
#define Button_Height  120*kScaleW   // 高
#define Button_Width (kScreenWidth - Start_X*2 - Width_Space)/2      // 宽
#define mainConfigBtnList @[@{@"title":@"开奖记录",@"color":@"#ec6464"},@{@"title":@"统计结果",@"color":@"#007aff"},@{@"title":@"路珠分析",@"color":@"#686868"},@{@"title":@"走势图",@"color":@"#0062ab"}]
@implementation TriolionHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i = 0 ; i < mainConfigBtnList.count; i++) {
            NSDictionary *dict = [mainConfigBtnList objectAtIndex:i];
            NSString *title = [dict objectForKey:@"title"];
            NSString *color = [dict objectForKey:@"color"];
            NSInteger index = i % 2;
            NSInteger page = i / 2;
            
            // 圆角按钮
            UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            aBt.tag = i;
            aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
            aBt.layer.masksToBounds = YES;
            aBt.layer.cornerRadius = 8;
            aBt.titleLabel.font = [UIFont systemFontOfSize:18];
            aBt.backgroundColor = [UIColor colorWithHexString:color];
            [aBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [aBt setTitle:title forState:UIControlStateNormal];
            [aBt addTarget:self action:@selector(abtAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:aBt];
        }
    }
    return self;
}
- (void)abtAction:(UIButton *)btn{
    if (_delegate&&[_delegate respondsToSelector:@selector(click:)]) {
        [_delegate click:btn.tag];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
