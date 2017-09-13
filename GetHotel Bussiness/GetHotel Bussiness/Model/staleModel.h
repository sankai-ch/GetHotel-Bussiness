//
//  staleModel.h
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/11.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface staleModel : NSObject
@property(strong,nonatomic)NSString *departure;
@property(strong,nonatomic)NSString *destination;
@property(strong,nonatomic)NSString *lowPrice;
@property(strong,nonatomic)NSString *highPrice;
@property(strong,nonatomic)NSString *startTime;
@property(strong,nonatomic)NSString *lowtimestr;
@property(strong,nonatomic)NSString *hightimestr;
- (instancetype)initWithDict: (NSDictionary *)dict;
@end
