//
//  ClickLoginCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ClickLoginCell.h"

@implementation ClickLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _loginButton.layer.cornerRadius = 6.0f;
    [_loginButton clipsToBounds];
//    _loginButton.backgroundColor = [UIColor colorWithHexString:@"0c71ba"];
    _loginButton.backgroundColor = [Tool getLoginButtonColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
