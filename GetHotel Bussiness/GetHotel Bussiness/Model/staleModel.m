//
//  staleModel.m
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/11.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "staleModel.h"

@implementation staleModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _departure=[Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@"未知出发地"];
        _destination=[Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@"未知目的地"];
        _lowPrice=[Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@"0"];
        _highPrice=[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@"0"];
        _startTime=[Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];
        
    }
    return self;
}
@end
