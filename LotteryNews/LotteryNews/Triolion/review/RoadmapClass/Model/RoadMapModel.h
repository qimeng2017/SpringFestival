//
//  RoadMapModel.h
//  StockMarket
//
//  Created by 邹壮壮 on 2017/3/15.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RoadMapModel : JSONModel
@property (nonatomic,strong)NSString *fCount;
@property (nonatomic,strong)NSString *sCount;
@property (nonatomic, strong)NSString *name;
@property (nonatomic,strong)NSString *fTotalCount;
@property (nonatomic,strong)NSString *sTotalCount;
@property (nonatomic,strong)NSString *closeTotal;
@property (nonatomic,strong)NSArray *data;
@property (nonatomic,strong)NSArray *extData;
@end
