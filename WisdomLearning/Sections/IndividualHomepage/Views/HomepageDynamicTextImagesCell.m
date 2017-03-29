//
//  HomepageDynamicTextImagesCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "HomepageDynamicTextImagesCell.h"

@implementation HomepageDynamicTextImagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setInfo:(ZSFreshInfo *)info{
    _info = info;
    _contentLabel.text = info.content;
    _timeLabel.text = info.createTime;
}

@end
