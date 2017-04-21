//
//  MoreTableViewCell.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/14.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "MoreTableViewCell.h"

@interface MoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nebrlable;
@property (weak, nonatomic) IBOutlet UILabel *timelable;
@property (weak, nonatomic) IBOutlet UIView *ballView;
@property (nonatomic, copy) NSString *lottory_number;

@end
@implementation MoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)historyModel:(MoreHistoryModel *)model{
    _nebrlable.text = [NSString stringWithFormat:@"%@期",model.lottery_nper];
    _timelable.text = model.lottery_time;
    _lottory_number = model.lottery_number;
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [self customBall];
}

- (void)customBall
{
    for (UIView *view in _ballView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x = 20;
    
    
    
    NSArray *nums = [_lottory_number componentsSeparatedByString:@","];
    NSUInteger count = nums.count;
    
    UIImage *ballImage = [UIImage imageNamed:@"ball_red"];
    x = (_ballView.frame.size.width - count*ballImage.size.width-(count-1)*5)/2;
    for (NSInteger index = 0; index < [nums count]; index ++) {
        
        UIButton *ballBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_red"] forState:UIControlStateNormal];
        ballBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [ballBtn setTitle:[nums objectAtIndex:index] forState:UIControlStateNormal];
        [ballBtn sizeToFit];
        ballBtn.frame = CGRectMake(x, 0, CGRectGetWidth(ballBtn.frame), CGRectGetHeight(ballBtn.frame));
        
        x += CGRectGetWidth(ballBtn.frame) + 5;
        
        [_ballView addSubview:ballBtn];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
