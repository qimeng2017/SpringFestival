//
//  CenterCollectionViewCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "CenterCollectionViewCell.h"

@interface CenterCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLable;

@end
@implementation CenterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContentRankModel:(RankListModel *)model{
    _nameLable.text = model.nickname;
    _accuracyLable.text = model.fore_data;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.images_url] placeholderImage:nil];
}
@end
