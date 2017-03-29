//
//  InputUserNameCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "InputUserNameCell.h"

@implementation InputUserNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _userNameIv.image = [ThemeInsteadTool imageWithImageName:@"username"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}


@end
