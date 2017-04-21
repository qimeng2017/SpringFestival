//
//  TriolionHeaderCell.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/6.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TriolionHeaderCellDelegate <NSObject>

- (void)click:(NSInteger)index;

@end
@interface TriolionHeaderCell : UITableViewCell
@property (nonatomic,weak)id<TriolionHeaderCellDelegate>delegate;
@end
