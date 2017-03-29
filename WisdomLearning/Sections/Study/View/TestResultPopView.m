//
//  TestResultPopView.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "TestResultPopView.h"

@implementation TestResultPopView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(45, 20, SCREEN_WIDTH/5*3-90, SCREEN_WIDTH/5*3-100)];
        icon.image = image;
        [self addSubview:icon];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, SCREEN_WIDTH/5*3-70, SCREEN_WIDTH/5*3-40, 20)];
        label.text = [NSString stringWithFormat:@"一共 %@ 题  已回答 %@ 题",title,subTitle];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, ViewMaxY(label)+5, SCREEN_WIDTH/5*3, 1)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, ViewMaxY(view), SCREEN_WIDTH/5*3/2,230-ViewMaxY(view));
        [leftBtn setTitle:@"确定交卷" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        leftBtn.tag = 1;
        [self addSubview:leftBtn];
        
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(ViewMaxX(leftBtn), ViewMaxY(view), 1, 230-ViewMaxY(view))];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView];
        
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(ViewMaxX(lineView), ViewMaxY(view), SCREEN_WIDTH/5*3/2,230-ViewMaxY(view));
        [rightBtn setTitle:@"返回检查" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        rightBtn.tag = 2;
        [self addSubview:rightBtn];
    }
    return self;
}

-(void)clickSubmitBtn:(UIButton*)btn
{
    if(_delegate){
        [self.delegate clickTestResultPopViewBtn:btn];
    }
}
@end
