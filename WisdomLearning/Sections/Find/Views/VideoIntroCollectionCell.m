//
//  VideoIntroCollectionCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "VideoIntroCollectionCell.h"

@implementation VideoIntroCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setCourseDesc:(NSString *)courseDesc{
    _courseDesc = courseDesc;
    _introLabel.text = courseDesc;
}



@end
