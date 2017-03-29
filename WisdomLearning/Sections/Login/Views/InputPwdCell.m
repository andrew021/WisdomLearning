//
//  InputPwdCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "InputPwdCell.h"

@implementation InputPwdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _passwordIv.image = [ThemeInsteadTool imageWithImageName:@"password"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
