//
//  OrderConfirmCell2.h
//  WisdomLearning
//
//  Created by Shane on 17/2/23.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmCell2 : UITableViewCell

@property (nonatomic, copy) NSString *courseIcon;  //课程icon
@property (nonatomic, copy) NSString *desc;  //课程name
@property (nonatomic, copy) NSString *price;  //课程价格

@property(nonatomic, weak) IBOutlet UIImageView *iconImageview;
@property(nonatomic, weak) IBOutlet UILabel *descLabel;
@property(nonatomic, weak) IBOutlet UILabel *priceLabel;

@end
