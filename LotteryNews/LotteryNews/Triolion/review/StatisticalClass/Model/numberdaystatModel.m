//
//  numberdaystatModel.m
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "numberdaystatModel.h"

@implementation numberdaystatModel
- (instancetype)initWith:(NSArray *)item{
    if (self = [super init]) {
        self.numbers = [NSMutableArray array];
        for (NSInteger i = 0; i<item.count; i++) {
            if (i==0) {
                self.time = item[i];
            }else{
                [self.numbers addObject:item[i]];
                
            }
        }
    }
    return self;
}
@end
