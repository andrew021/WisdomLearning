//
//  SystemMessageCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSLearnCircleListModel.h"
@interface SystemMessageCell : UITableViewCell

@property (nonatomic,strong) UIImageView * avatarImage;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UIView * pointView;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) SystemMsgModel * model;



@end
