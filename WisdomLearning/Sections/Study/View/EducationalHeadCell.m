//
//  EducationalHeadCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "EducationalHeadCell.h"

@implementation EducationalHeadCell

- (void)awakeFromNib {
    // Initialization code
    
    _titleIv.image = [ThemeInsteadTool imageWithImageName:@"toutiao"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
