//
//  OfferModel.m
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/8.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "OfferModel.h"

@implementation OfferModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _aviationdemandtitle=[Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@"暂无标题"];
        _aviationdemanddetail=[Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@"暂无备注"];
        _startime=[Utilities nullAndNilCheck:dict[@"start_time"] replaceBy:@""];
        _lowprice=[[Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:0] integerValue];
        _highprice=[[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:0] integerValue];
        
    }
    return self;
}
@end
