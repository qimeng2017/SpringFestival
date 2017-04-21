//
//  TriolionCell.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/1/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TriolionModel.h"

@protocol TriolionCellDelegate <NSObject>

- (void)shareTriolionModel:(TriolionModel *)model;

@end
@interface TriolionCell : UITableViewCell
@property (nonatomic, weak)id<TriolionCellDelegate>delegate;
@property (nonatomic, strong) TriolionModel *triolionModel;
@end
