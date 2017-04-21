//
//  ScrollLineView.h
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockModel.h"
@interface ScrollLineView : UIScrollView
- (void)reloadScrollViewWithDays:(NSArray *)days;
@end
