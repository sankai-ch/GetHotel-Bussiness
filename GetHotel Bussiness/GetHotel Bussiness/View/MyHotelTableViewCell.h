//
//  MyHotelTableViewCell.h
//  GetHotel Bussiness
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHotelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *zoomIV;
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImg;
@property (weak, nonatomic) IBOutlet UILabel *hotelDescribeLabel;

@property (weak, nonatomic) IBOutlet UILabel *hotelAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelPriceLabel;

@end
