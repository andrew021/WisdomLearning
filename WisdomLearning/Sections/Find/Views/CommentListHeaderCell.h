//
//  CommentListHeaderCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/14.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListHeaderCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *headerImageview;
@property(nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *createTimeLabel;
@property(nonatomic, strong) IBOutlet UILabel *contentLabel;

@property(nonatomic, strong) ZSReplyListInfo *replyInfo;

@end
