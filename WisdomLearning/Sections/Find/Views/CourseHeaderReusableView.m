//
//  CourseHeaderReusableView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CourseHeaderReusableView.h"

@implementation CourseHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 8, 2, frame.size.height - 16)];
        lineLabel.backgroundColor = kMainThemeColor;
        [self addSubview:lineLabel];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 0, 150.0, frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, frame.size.height)];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_moreBtn];
    }
    return self;
}


@end
