//
//  addHotelModel.m
//  GetHotel Bussiness
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "addHotelModel.h"

@implementation addHotelModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"未知"];
        //NSLog(@"123:::%@",_hotelName);
    }
    return self;
}
@end
