//
//  LNGuessView.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "LNGuessView.h"

@interface LNGuessView ()
@property (weak, nonatomic) IBOutlet UILabel *lottonryName;

@end
@implementation LNGuessView
+ (NSString *)nibName
{
    return @"LNGuessView";
}
- (IBAction)changBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellDidClickChangeBtn:)]) {
        [self.delegate cellDidClickChangeBtn:self];
    }
}



@end
