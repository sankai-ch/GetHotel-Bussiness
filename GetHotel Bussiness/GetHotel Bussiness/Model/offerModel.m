//
//  offerModel.m
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/11.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "offerModel.h"

@implementation offerModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _aviation_demand_title=[Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@"未知标题"];
        _aviation_demand_detail=[Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@"未知备注"];
        _start_time=[Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];
        _low_price=[Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@""];
        _high_price=[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""];
        
    }
    return self;
}
@end
