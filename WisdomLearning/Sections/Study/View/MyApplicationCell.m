//
//  MyApplicationCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyApplicationCell.h"

@implementation MyApplicationCell

- (void)awakeFromNib {
    // Initialization code
    
    self.courseBtn.layer.cornerRadius = 5.0f;
    self.courseBtn.layer.borderColor = kMainThemeColor.CGColor;
    self.courseBtn.layer.borderWidth = 1.0f;
    [self.courseBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    
    self.trainBtn.layer.cornerRadius = 5.0f;
    self.trainBtn.layer.borderColor = kMainThemeColor.CGColor;
    self.trainBtn.layer.borderWidth = 1.0f;
    [self.trainBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setList:(MyTenantList *)list
{
    _list = list;
    [self.headerImage sd_setImageWithURL:[list.logoImg stringToUrl] placeholderImage:kPlaceDefautImage];
    self.titleLabel.text = list.name;
}

@end
