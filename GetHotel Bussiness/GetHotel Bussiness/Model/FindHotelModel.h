//
//  FindHotelModel.h
//  GetHotel Bussiness
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindHotelModel : NSObject

@property (strong, nonatomic) NSString *hotelName;
@property (strong, nonatomic) NSString *hotelType;
@property (nonatomic) NSInteger price;
@property (strong, nonatomic) NSString *hotelImg;
@property (nonatomic) NSInteger ID;
- (instancetype)initWithDict: (NSDictionary *)dict;

@end
