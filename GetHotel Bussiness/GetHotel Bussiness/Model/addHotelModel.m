//
//  addHotelModel.m
//  GetHotel Bussiness
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "addHotelModel.h"

@implementation addHotelModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"未知"];
    }
    return self;
}
@end
