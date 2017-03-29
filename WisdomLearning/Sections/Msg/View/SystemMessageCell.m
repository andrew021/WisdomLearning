//
//  SystemMessageCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SystemMessageCell.h"

@implementation SystemMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

-(void)setup
{
//    _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
//    _avatarImage.image = [ThemeInsteadTool imageWithImageName:@"system_message"];
//    _avatarImage.layer.cornerRadius = 40/2;
//    _avatarImage.layer.masksToBounds = YES;
//    
//    [self.contentView addSubview:_avatarImage];
    
    
//    _pointView = [[UIView alloc]initWithFrame:CGRectMake(50, 10, 8, 8)];
//    _pointView.layer.cornerRadius = 8/2;
//    _pointView.backgroundColor = KMainRed;
//    [self.contentView addSubview:_pointView];
//    
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake( SCREEN_WIDTH-150, 10, 140, 20)];
    _timeLabel.textColor = KMainTextGray;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.text = @"2017-01-23";
    [self.contentView addSubview:_timeLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-70, 20)];
    _nameLabel.text = @"学习反馈:课程视频看不了";
    _nameLabel.textColor = KMainTextGray;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_nameLabel];
    
    
  
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = KMainTextBlack;
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = @"课程视频看不了";
    [self.contentView addSubview:_contentLabel];
    
    
}

-(void)setModel:(SystemMsgModel *)model
{
    _model = model;
    self.nameLabel.text = model.senderName;
    self.timeLabel.text = model.sendTime;

    CGFloat height = [GetHeight getHeightWithContent:model.content width:SCREEN_WIDTH-80 font:14];
    _contentLabel.text = model.content;
    _contentLabel.frame = CGRectMake(15, 35, SCREEN_WIDTH-25, height);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
