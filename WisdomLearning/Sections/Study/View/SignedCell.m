//
//  SignedCell.m
//  WisdomLearning
//
//  Created by Shane on 16/11/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SignedCell.h"

@implementation SignedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.clickBtn.layer.cornerRadius = 8.0f;
    self.clickBtn.layer.borderColor = KMainBlue.CGColor;
    self.clickBtn.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
