//
//  CourseLearnCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CourseLearnCell.h"

@implementation CourseLearnCell

- (void)awakeFromNib {
    // Initialization code
    [_cancelBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [_studyBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
