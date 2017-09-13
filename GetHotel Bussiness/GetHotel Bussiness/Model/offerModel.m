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
        _low_price=[Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@"0"];
        _high_price=[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@"0"];
        _lowtimestr=[Utilities nullAndNilCheck:dict[@"set_low_time_str"] replaceBy:@""];
        _hightimestr=[Utilities nullAndNilCheck:dict[@"set_high_time_str"] replaceBy:@""];
        _aviation_demand_id=[[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""]integerValue];
        
        
        
    }
    return self;
}
@end
