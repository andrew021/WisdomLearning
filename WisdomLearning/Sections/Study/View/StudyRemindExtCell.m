//
//  StudyRemindExtCell.m
//  WisdomLearning
//
//  Created by Shane on 16/11/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "StudyRemindExtCell.h"

@implementation StudyRemindExtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lookButton.layer.cornerRadius = 5;
    _lookButton.layer.masksToBounds = YES;
    _lookButton.layer.borderWidth = 1;
    _lookButton.layer.borderColor = kMainThemeColor.CGColor;
    [_lookButton setTitleColor:kMainThemeColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRemindContent:(NSString *)remindContent{
    _remindContentLabel.text = remindContent;
}

@end
