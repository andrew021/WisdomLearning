//
//  NewThingCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrowdFundingImageView.h"
#import "ZSLearnCircleListModel.h"
@interface NewThingCell : UITableViewCell

@property (nonatomic,strong) UIImageView * avatarImage;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UIButton * commentBtn;
@property (nonatomic,strong) UIButton * likeBtn;
@property (nonatomic,strong) UILabel * commentLabel;
@property (nonatomic,strong) UILabel * likeLabel;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) CrowdFundingImageView * imageViews;
@property (nonatomic,strong) NewThingModel * model;

@end
