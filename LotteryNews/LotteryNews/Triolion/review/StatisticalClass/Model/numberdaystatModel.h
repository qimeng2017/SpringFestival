//
//  numberdaystatModel.h
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface numberdaystatModel : JSONModel
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSMutableArray *numbers;
- (instancetype)initWith:(NSArray *)item;
@end
