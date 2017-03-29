//
//  SpecialHeaderView.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SpecialHeaderView.h"

@implementation SpecialHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    _scrLabel.textColor = kMainThemeColor;
    _certificateLabel.textColor = kMainThemeColor;
    _numLabel.textColor = kMainThemeColor;
    [_detailBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    _pullUpImage.image = [ThemeInsteadTool imageWithImageName:@"pull_up"];
}

@end
