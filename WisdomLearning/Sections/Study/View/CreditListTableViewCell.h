//
//  CreditListTableViewCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoDetailModel.h"

@interface CreditListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) MyCreditModel * model;

@end
