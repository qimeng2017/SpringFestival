//
//  NumberdaystatCell.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "NumberdaystatCell.h"

@interface NumberdaystatCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UIScrollView *ballSCrollview;

@end
@implementation NumberdaystatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ballSCrollview.showsVerticalScrollIndicator = NO;
    self.ballSCrollview.showsHorizontalScrollIndicator = NO;
    // Initialization code
}
- (void)setNumberModel:(numberdaystatModel*)model{
    self.timeLable.text = model.time;
    
    [self customBall:model.numbers];
}
- (void)customBall:(NSArray *)nums
{
    for (UIView *view in _ballSCrollview.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x = 0;
    
    
    
    
    NSUInteger count = nums.count;
    
    UIImage *ballImage = [UIImage imageNamed:@"ball_red"];
    CGFloat contentWidth =  count*ballImage.size.width+(count-1)*10;
    if (CGRectGetWidth(self.ballSCrollview.frame)>contentWidth) {
        x = (CGRectGetWidth(self.ballSCrollview.frame)-contentWidth)/2;
    }
    self.ballSCrollview.contentSize = CGSizeMake(contentWidth, 0);
    for (NSInteger index = 0; index < [nums count]; index ++) {
        
        UIButton *ballBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ballBtn setBackgroundImage:[UIImage imageNamed:@"ball_red"] forState:UIControlStateNormal];
        ballBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [ballBtn setTitle:[nums objectAtIndex:index] forState:UIControlStateNormal];
        [ballBtn sizeToFit];
        ballBtn.frame = CGRectMake(x, (CGRectGetHeight(self.ballSCrollview.frame)- CGRectGetHeight(ballBtn.frame))/2, CGRectGetWidth(ballBtn.frame), CGRectGetHeight(ballBtn.frame));
        
        x += CGRectGetWidth(ballBtn.frame) + 10;
        
        [_ballSCrollview addSubview:ballBtn];
        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
