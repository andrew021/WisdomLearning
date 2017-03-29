//
//  CreditListTableViewCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CreditListTableViewCell.h"

@implementation CreditListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleImageView.layer.cornerRadius = 32/2;
    self.titleImageView.layer.masksToBounds = YES;
}

-(void)setModel:(MyCreditModel *)model
{
    _model = model;
    self.timeLabel.text = model.createTime;
    self.titleLabel.text = model.name;

    self.creditLabel.text = [NSString stringWithFormat:@"%ld",model.changeValue];
    //[NSString stringWithFormat:@"获得学分 %ld",model.changeValue];
  
    switch (model.type) {
        case 1:
           // self.timeLabel.text = @"课程学习";
            self.titleImageView.image = [UIImage imageNamed:@"courseLearn_icon"];
            break;
        case 2:
           // self.timeLabel.text = @"论坛研讨";
            self.titleImageView.image = [UIImage imageNamed:@"tribune_icon"];
            break;
        case 3:
          //  self.timeLabel.text = @"阅读简报";
            self.titleImageView.image = [UIImage imageNamed:@"readBriefing_icon"];
            break;
        case 4:
           // self.timeLabel.text = @"线下学分";
            self.titleImageView.image = [UIImage imageNamed:@"courseWork_icon"];
            break;
        case 5:
          //  self.timeLabel.text = @"其他";
            self.titleImageView.image = [UIImage imageNamed:@"courseTest_icon"];
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
