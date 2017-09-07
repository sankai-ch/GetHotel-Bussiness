//
//  CityListModel.h
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityListModel : NSObject

@property (strong, nonatomic) NSString *tip;
@property (strong, nonatomic) NSMutableArray *cityArr;

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
