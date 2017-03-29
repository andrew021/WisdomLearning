//
//  LoginFooterView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "LoginFooterView.h"

@implementation LoginFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [_qqLoginButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"qq"] forState:UIControlStateNormal];
    [_weixinLoginButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"weixin"] forState:UIControlStateNormal];
    [_weiboLoginButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"weibo"] forState:UIControlStateNormal];
    
    [_vistorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
