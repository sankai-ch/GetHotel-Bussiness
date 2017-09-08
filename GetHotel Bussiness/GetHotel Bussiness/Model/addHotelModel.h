//
//  addHotelModel.h
//  GetHotel Bussiness
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addHotelModel : NSObject
@property (strong, nonatomic) NSString *hotelName;
- (instancetype)initWithDict: (NSDictionary *)dict;
@end
