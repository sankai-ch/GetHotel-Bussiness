//
//  quoteTableViewCell.h
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/2.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CitytoLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;

@end
