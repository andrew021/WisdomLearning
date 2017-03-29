//
//  ClassCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ClassCell.h"

@implementation ClassCell

- (void)awakeFromNib {
    // Initialization code
    
//    [_selectBtn setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"blue_circle"] forState:UIControlStateNormal];
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
    
    if (list.classType == 1 ) {
        _statusImage.image = [UIImage imageNamed:@"just_face"];
    } else {
        _statusImage.image = [ThemeInsteadTool imageWithImageName:@"just_net"];
    }
    _classNameLabel.text = list.className;
    _dateLabel.text = [NSString stringWithFormat:@"报名时间：%@ 至 %@",list.signStartTime,list.signEndTime];
    if (list.isViewFlag) {
        [_selectBtn setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"selected"] forState:UIControlStateNormal];
    } else {
        [_selectBtn setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"blue_circle"] forState:UIControlStateNormal];
    }
}

@end
