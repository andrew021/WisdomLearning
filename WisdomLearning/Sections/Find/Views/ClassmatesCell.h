//
//  ClassmatesCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSLearnCircleListModel.h"

@interface ClassmatesCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic,strong) CLassMateListModel * model;

@end
