//
//  MoreHistoryModel.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/6.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MoreHistoryModel : JSONModel
@property (nonatomic, strong) NSString *lottery_date;
@property (nonatomic, strong) NSString *lottery_time;
@property (nonatomic, strong) NSString *lottery_nper;
@property (nonatomic, strong) NSString *lottery_number;
@end
