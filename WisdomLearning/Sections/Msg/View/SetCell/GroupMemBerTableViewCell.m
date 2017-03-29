//
//  GroupMemBerTableViewCell.m
//  BigMovie
//
//  Created by hfcb001 on 16/4/8.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "GroupMemBerTableViewCell.h"

@implementation GroupMemBerTableViewCell

- (void)awakeFromNib {
    self.avatar.layer.cornerRadius = 48/2;
    self.avatar.clipsToBounds = YES;
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.deleteBtn.backgroundColor = [UIColor whiteColor];
    self.msgLabel.textColor = kLineLight;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
