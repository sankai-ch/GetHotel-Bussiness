//
//  offerModel.h
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/11.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface offerModel : NSObject
@property(strong,nonatomic)NSString *aviation_demand_title;
@property(strong,nonatomic)NSString *start_time;
@property(strong,nonatomic)NSString *aviation_demand_detail;
@property(strong,nonatomic)NSString *low_price;
@property(strong,nonatomic)NSString *high_price;

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
