//
//  NewGroupCell.h
//  BigMovie
//
//  Created by Shane on 16/4/12.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBaseTableViewCell.h"
#import "ZSMessageGroupModel.h"

static CGFloat NewGroupCellMinHeight = 75.f;
static NSString *NewGroupCellIdentifier = @"NewGroupCell";

@interface NewGroupCell : kBaseTableViewCell

@property(nonatomic, strong) ZSMessageGroupModel *group;

//群组名
@property(nonatomic, weak) IBOutlet UILabel *lbGroupSubject;
@property(nonatomic, weak) IBOutlet UIImageView *ivAvatar;

@end
