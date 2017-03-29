//
//  StudyRemindCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "StudyRemindCell.h"

@implementation StudyRemindCell

- (void)awakeFromNib {
    // Initialization code
    
    self.clickBtn.layer.cornerRadius = 8.0f;
    self.clickBtn.layer.borderColor = kMainThemeColor.CGColor;
    self.clickBtn.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
