//
//  SearchBuddyCell.h
//  BigMovie
//
//  Created by Shane on 16/4/15.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBaseTableViewCell.h"
#import "ZSMessageSearchModel.h"

static CGFloat SearchBuddyCellMinHeight = 80.f;
static NSString *SearchBuddyCellIdentifier = @"SearchBuddyCell";

@interface SearchBuddyCell : kBaseTableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@property(weak, nonatomic) IBOutlet UILabel* lbNickName;

@property(strong, nonatomic) NSString *conversationId;
@property(strong, nonatomic) NSString *title;
@property(nonatomic, assign) EMConversationType conversationType;
@property(nonatomic, strong) ZSMessageFriendListModel *model;
@property(nonatomic, assign) BOOL isGroup;
@property(nonatomic, copy) NSString *searchText;

@end
