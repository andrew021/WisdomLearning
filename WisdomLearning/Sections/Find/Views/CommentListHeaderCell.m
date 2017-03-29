//
//  CommentListHeaderCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/14.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CommentListHeaderCell.h"
#import "NSString+Utilities.h"
@implementation CommentListHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headerImageview.layer.cornerRadius = self.headerImageview.frame.size.width/2;
    self.headerImageview.clipsToBounds = YES;
    self.userNameLabel.textColor = kMainThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setReplyInfo:(ZSReplyListInfo *)replyInfo{
    _userNameLabel.text = replyInfo.userName;
    _createTimeLabel.text = replyInfo.createTime;
    _contentLabel.text = [replyInfo.content base64Decode];
    [_headerImageview sd_setImageWithURL:[replyInfo.userIcon stringToUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
}

@end
