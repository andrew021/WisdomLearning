//
//  ChangeClassCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/16.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ChangeClassCell.h"

@implementation ChangeClassCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bgView.layer.cornerRadius = 5.0f;
    self.bgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setList:(ClassList *)list
{
    _list = list;
    
    if (list.classType == 1) {
        _statusImage.image = [UIImage imageNamed:@"just_face"];
    } else {
        _statusImage.image = [ThemeInsteadTool imageWithImageName:@"just_net"];
    }
    _titleLabel.text = list.className;
    if (list.joinFlag) {
        [_clickButton setBackgroundImage:[UIImage imageNamed:@"gary_select"] forState:UIControlStateNormal];
        _clickButton.enabled = NO;
    } else {
        _clickButton.enabled = YES;
        if (list.isViewFlag) {
            [_clickButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"selected"] forState:UIControlStateNormal];
        } else {
            [_clickButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"blue_circle"] forState:UIControlStateNormal];
        }
    }
    _contentLabel.text = [NSString stringWithFormat:@"报名时间：%@ 至 %@",list.signStartTime,list.signEndTime];
}

- (void)setChangeList:(ClassList *)changeList
{
    _changeList = changeList;
    
    if (changeList.classType == 1) {
        _statusImage.image = [UIImage imageNamed:@"just_face"];
    } else {
        _statusImage.image = [ThemeInsteadTool imageWithImageName:@"just_net"];
    }
    _titleLabel.text = changeList.className;
    if (changeList.joinFlag) {
        [_clickButton setBackgroundImage:[UIImage imageNamed:@"gary_select"] forState:UIControlStateNormal];
        _clickButton.enabled = NO;
    } else {
        _clickButton.enabled = YES;
        if (changeList.isViewFlag) {
            [_clickButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"selected"] forState:UIControlStateNormal];
        } else {
            [_clickButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"blue_circle"] forState:UIControlStateNormal];
        }
    }
    _contentLabel.text = [NSString stringWithFormat:@"开放时间：%@ 至 %@",changeList.studyStartTime,changeList.studyEndTime];
}

@end
