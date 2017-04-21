//
//  StockModel.h
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/9.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockModel : NSObject<NSCopying>
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * profit;
@end
