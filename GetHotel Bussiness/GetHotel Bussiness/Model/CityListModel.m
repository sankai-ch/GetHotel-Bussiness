//
//  CityListModel.m
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "CityListModel.h"

@implementation CityListModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.tip = [Utilities nullAndNilCheck:dict[@"short"] replaceBy:@"热门城市"];
        self.cityArr = [NSMutableArray new];
        if ([self.tip isEqualToString:@"热门城市"]) {
            for (NSString *city in dict[@"hotCity"]) {
                [self.cityArr addObject:[Utilities nullAndNilCheck:city replaceBy:@""]];
            }
        }
        else{
            for (NSString *city in dict[@"city"]) {
                [self.cityArr addObject:[Utilities nullAndNilCheck:city replaceBy:@""]];
            }
        }
    }
    return self;
}
@end
