//
//  FindHotelModel.m
//  GetHotel Bussiness
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "FindHotelModel.h"

@implementation FindHotelModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"未知"];
        _hotelType = [Utilities nullAndNilCheck:dict[@"hotel_type"] replaceBy:@"未知"];
        _price = [[Utilities nullAndNilCheck:dict[@"price"] replaceBy:0] integerValue];
        _hotelImg = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
        _ID = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0] integerValue];
    }
    return self;
}

@end
