//
//  RoadMapCell.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "RoadMapCell.h"

@interface RoadMapCell ()
@property (nonatomic, assign)NSInteger pageCount;
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic, strong)UIView *backView;
@end
@implementation RoadMapCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        
    }
    return self;
}
- (void)initUI{
    for (NSInteger i = 0; i<_pageCount; i++) {
        
    }
    
}
- (void)roadMapModel:(RoadMapModel *)model{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (NSInteger i = 0; i<2; i++) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 30)];
        lable.backgroundColor = [UIColor colorWithHexString:@"#0ca9ec"];
        lable.textAlignment = NSTextAlignmentCenter;
        
        lable.textColor = [UIColor whiteColor];
        NSDictionary *firstDict = model.extData[0];
        NSString *daName = [firstDict objectForKey:@"Name"];
        NSNumber *daNumber = [firstDict objectForKey:@"Count"];
        NSString *daCount = [NSString stringWithFormat:@"%@", daNumber];
        NSDictionary *secondDict = model.extData[1];
        NSString *xiaoName = [secondDict objectForKey:@"Name"];
        NSNumber *xiaoNumber = [secondDict objectForKey:@"Count"];
        NSString *xiaoCount = [NSString stringWithFormat:@"%@", xiaoNumber];
        NSString *text = [NSString stringWithFormat:@"%@:%@(%@)%@(%@)",model.name,daName,daCount,xiaoName,xiaoCount];
        lable.text = text;
        [self addSubview:lable];
    }
    for (NSInteger i=0; i<model.data.count; i++) {
        NSDictionary *dict = [model.data objectAtIndex:i];
        NSArray *datas = [dict objectForKey:@"data"];
        UIView *ballView = [[UIView alloc]initWithFrame:CGRectMake(i*roadBallWidth, 30, roadBallWidth, 220)];
        
        [self addSubview:ballView];
        for (NSInteger j = 0; j<datas.count; j++) {
            NSDictionary *dataDict = [datas objectAtIndex:j];
            NSString *result = [dataDict objectForKey:@"result"];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, j*roadBallWidth, roadBallWidth, roadBallWidth)];
            lable.text = result;
            lable.textAlignment = NSTextAlignmentCenter;
            
            lable.font = [UIFont systemFontOfSize:12];
            [ballView addSubview:lable];
        }
        
        
        
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
