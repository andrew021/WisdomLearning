//
//  HomepageHeaderView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "HomepageHeaderView.h"

//@interface HomepageHeaderView()<UIGestureRecognizerDelegate>
//
//@end

@implementation HomepageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    _avaterImageView.layer.cornerRadius = CGRectGetWidth(_avaterImageView.frame)/2;
    _avaterImageView.layer.masksToBounds = YES;
    _friendLabel.textColor = kMainThemeColor;
    _backgroundIv.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_backgroundIv addGestureRecognizer:tapGr];
}

-(void)tapAction:(UITapGestureRecognizer *)gr{
    if (_isSelf && _theDelegate && [_theDelegate respondsToSelector:@selector(clickBackgroundImage)]) {
        [_theDelegate clickBackgroundImage];
    }
}

-(void)setHomeImageUrl:(NSString *)homeImageUrl{
    _homeImageUrl = homeImageUrl;
    [_backgroundIv sd_setImageWithURL:[homeImageUrl stringToUrl] placeholderImage:kPlaceDefautImage];
}

@end
