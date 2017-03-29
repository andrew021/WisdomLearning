//
//  OrderConfirmCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmCell : UITableViewCell

@property (nonatomic, copy) NSString *courseIcon;  //课程icon
@property (nonatomic, copy) NSString *courseName;  //课程name
@property (nonatomic, copy) NSString *coursePrice;  //课程价格


@property(nonatomic, weak) IBOutlet UIImageView *iconImageview;
@property(nonatomic, weak) IBOutlet UILabel *courseNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *coursePriceLabel;

@end
