//
//  LongDragonCellTableViewCell.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "LongDragonCellTableViewCell.h"

@interface LongDragonCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UILabel *categoryLable;
@property (weak, nonatomic) IBOutlet UILabel *openLable;

@end
@implementation LongDragonCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setLongDragonModel:(LongDrageModel *)model{
    self.typeLable.text = model.type;
    self.categoryLable.text = model.category;
    self.openLable.text = model.openPeriods;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
