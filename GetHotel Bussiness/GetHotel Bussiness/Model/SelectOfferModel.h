//
//  SelectOfferModel.h
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectOfferModel : NSObject
@property(nonatomic)NSInteger finalprice;
@property(nonatomic)NSInteger weight;
@property(strong,nonatomic)NSString *aviationCompany;
@property(strong,nonatomic)NSString *aviationCabin;
@property(strong,nonatomic)NSString *in_time_str;
@property(strong,nonatomic)NSString *out_time_str;
@property(strong,nonatomic)NSString *departure;
@property(strong,nonatomic)NSString *destination;
@property(strong,nonatomic)NSString *flightNo;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
