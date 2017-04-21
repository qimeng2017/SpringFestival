//
//  StockModel.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "StockModel.h"

@implementation StockModel
- (id)copyWithZone:(NSZone *)zone
{
    StockModel * model = [[StockModel alloc] init];
    model.date = self.date;
    model.profit = self.profit;
    return model;
}
@end
