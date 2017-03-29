//
//  SignupListCell.m
//  WisdomLearning
//
//  Created by Shane on 16/11/19.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SignupListCell.h"

@implementation SignupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setSignupModel:(Signup *)signupModel{
    _signupModel = signupModel;
    _nameLabel.text = signupModel.name;
    _locationLabel.text = signupModel.location;
    _timeLabel.text = signupModel.signupTime;
    
}
@end
