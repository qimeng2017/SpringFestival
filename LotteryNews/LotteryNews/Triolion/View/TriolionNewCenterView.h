//
//  TriolionNewCenterView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/7.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HXTitleSize 12.0 //标签字体大小
#define HXIcoAndTitleSpace 10.0 //图标和标题间的间隔
#define boderView_H  100
#define HXOriginTop 15.0
#define viewSpace 20.0

@protocol TriolionNewCenterViewDelegate <NSObject>

- (void)clickLottory:(NSInteger)didSelectIndex;

@end
@interface TriolionNewCenterView : UIView
@property (nonatomic, weak)id<TriolionNewCenterViewDelegate>delegate;
+(CGFloat)getHeight;
@end
