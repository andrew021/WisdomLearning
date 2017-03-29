//
//  SpecialListCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SpecialListCell.h"

@implementation SpecialListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setList:(UserClassList *)list
{
    _list = list;
    
    [self.headerImage sd_setImageWithURL:[list.image stringToUrl] placeholderImage:kPlaceDefautImage];
    self.classLabel.text = list.className;
    self.organizationLabel.text = list.platform;
    if (list.type == 1) {
        self.justImage.image = [ThemeInsteadTool imageWithImageName:@"just_net"];
    } else {
        self.justImage.image = [UIImage imageNamed:@"just_face"];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",list.startTime,list.endTime];
}

@end
