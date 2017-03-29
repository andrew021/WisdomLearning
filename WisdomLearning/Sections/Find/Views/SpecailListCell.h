//
//  SpecailListCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSLearnCircleListModel.h"

@interface SpecailListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotLabel;
@property (strong, nonatomic) IBOutlet UIImageView *riseIcon;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic,strong) ZSLearnCircleListModel * model;

@end
