//
//  MyCurrencyCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoDetailModel.h"

@interface MyCurrencyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) MyCreditModel * model;
@end
