//
//  LNGuessBgView.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "LNGuessBgView.h"

@implementation LNGuessBgView
+ (NSString *)nibName
{
    return @"LNGuessBgView";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.imageViewBg.clipsToBounds = YES;
}



@end
