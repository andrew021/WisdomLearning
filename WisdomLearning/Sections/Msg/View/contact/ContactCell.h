//
//  ContactCell.h
//  BigMovie
//
//  Created by Shane on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//

//#import "ZSMessageFriendListModel.h"
#import "kBaseTableViewCell.h"
#import <UIKit/UIKit.h>

static CGFloat ContactCellMinHeight = 75.0f;
static NSString* ContactCellIdentifier = @"ContactCell";

@interface ContactCell : kBaseTableViewCell

@property (strong, nonatomic) ZSMessageFriendListModel* model;

//昵称
@property (weak, nonatomic) IBOutlet UILabel* lbNickName;
//图像
@property (weak, nonatomic) IBOutlet UIImageView* ivAvatar;
//个性签名
@property (weak, nonatomic) IBOutlet UILabel* lbIntro;

@end
