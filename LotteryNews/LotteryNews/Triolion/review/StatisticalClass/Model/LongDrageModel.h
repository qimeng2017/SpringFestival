//
//  LongDrageModel.h
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LongDrageModel : JSONModel
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *openPeriods;
@end
