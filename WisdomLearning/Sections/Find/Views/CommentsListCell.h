//
//  CommentsListCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/14.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "ZSReplyListModel.h"

@interface CommentsListCell : UITableViewCell

@property (nonatomic, copy) NSString* summaryText;

@property (nonatomic, strong) TTTAttributedLabel* summaryLabel;

@property (nonatomic, strong) ZSReplyInfo *replyModel;

@end
