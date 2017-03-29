//
//  ClassBulletinCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ClassBulletinCell.h"

@implementation ClassBulletinCell

- (void)awakeFromNib {
    // Initialization code
    
    _lookButton.layer.cornerRadius = 5;
    _lookButton.layer.masksToBounds = YES;
    _lookButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
