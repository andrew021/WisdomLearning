//
//  SeeMoreView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/13.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SeeMoreView.h"

@implementation SeeMoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *seeMoreBtn = [[UIButton alloc] init];
        [self addSubview:seeMoreBtn];
        seeMoreBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [seeMoreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [seeMoreBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        [seeMoreBtn addTarget:self action:@selector(seeMore:) forControlEvents:UIControlEventTouchUpInside];
        [seeMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(100);
        }];
        
        seeMoreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        
        UIImageView *pull = [[UIImageView alloc] init];
        [self addSubview:pull];
        [pull setImage:[ThemeInsteadTool imageWithImageName:@"pull"]];
        [pull mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(seeMoreBtn);
            make.right.mas_equalTo(seeMoreBtn.mas_right).offset(-5);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(15);
        }];

    }
    return self;
}

-(void)seeMore:(UIButton *)sender{
    NSLog(@"I want to see more");
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(seeMore:)]) {
        [_theDelegate seeMore:self.currentIndexPath];
    }
}

@end
