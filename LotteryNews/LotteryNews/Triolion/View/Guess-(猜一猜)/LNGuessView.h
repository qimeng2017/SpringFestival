//
//  LNGuessView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNGuessView;
@protocol LNGuessViewDelegate <NSObject>

@optional
- (void)cellDidClickChangeBtn:(LNGuessView *)GuessView;

@end
@interface LNGuessView : UIView
@property (nonatomic, weak) id<LNGuessViewDelegate>delegate;
+ (NSString *)nibName;
@end
