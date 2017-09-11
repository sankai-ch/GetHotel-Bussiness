//
//  OfferModel.h
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/8.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferModel : NSObject
@property(strong,nonatomic)NSString *aviationdemandtitle;
@property(strong,nonatomic)NSString *aviationdemanddetail;
@property(strong,nonatomic)NSString *startime;
@property(nonatomic)NSInteger lowprice;
@property(nonatomic)NSInteger highprice;

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
