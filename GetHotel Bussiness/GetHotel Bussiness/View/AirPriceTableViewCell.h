//
//  AirPriceTableViewCell.h
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirPriceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *DateCityAirTicket;
@property (weak, nonatomic) IBOutlet UILabel *PriceDuring;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatOfCompany;

@end
