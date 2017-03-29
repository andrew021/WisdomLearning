//
//  MakeCommentView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MakeCommentView.h"
#import "ZSImageTextButton.h"

@implementation MakeCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
  
}

-(instancetype )initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_clickTfBlock) {
        _clickTfBlock();
    }
    return NO;
}

-(void)setNeedReward:(BOOL)needReward{
    
    //award comment
    _needReward = needReward;
    [self removeAllSubviews];
    
    if (!needReward) {
        ZSImageTextButton *commentButton = [[ZSImageTextButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-60, 0, 60, CGRectGetHeight(self.frame)) andImageLeft:YES andImage:[UIImage imageNamed:@"comment"] andTitle:@"评论" andTitleFont:[UIFont systemFontOfSize:14]];
        [commentButton addTarget:self action:@selector(commentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:commentButton];
        
        
        _theCommentTf = [[UITextField alloc] initWithFrame:CGRectMake(5, (CGRectGetHeight(self.frame)-30)/2, CGRectGetWidth(self.frame)-80, 30)];
        [self addSubview:_theCommentTf];
        _theCommentTf.borderStyle = UITextBorderStyleRoundedRect;
        _theCommentTf.delegate = self;
        
    }else{
        
        ZSImageTextButton *commentButton = [[ZSImageTextButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-150, 0, 60, CGRectGetHeight(self.frame)) andImageLeft:YES andImage:[UIImage imageNamed:@"comment"] andTitle:@"评论" andTitleFont:[UIFont systemFontOfSize:14]];
        [commentButton addTarget:self action:@selector(commentClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentButton];
        
        
        ZSImageTextButton *awardButton = [[ZSImageTextButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-60, 0, 60, CGRectGetHeight(self.frame)) andImageLeft:YES andImage:[UIImage imageNamed:@"award"] andTitle:@"打赏" andTitleFont:[UIFont systemFontOfSize:14]];
        [awardButton addTarget:self action:@selector(awardClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:awardButton];
        
        _theCommentTf = [[UITextField alloc] initWithFrame:CGRectMake(5, (CGRectGetHeight(self.frame)-30)/2, CGRectGetWidth(self.frame)-160, 30)];
        [self addSubview:_theCommentTf];
        _theCommentTf.borderStyle = UITextBorderStyleRoundedRect;
        _theCommentTf.delegate = self;

    }
}

-(void)commentClicked:(UIButton *)sender{
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(wishToComment)]) {
        [_theDelegate wishToComment];
    }
}

-(void)awardClicked:(UIButton *)sender{
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(wishToAward)]) {
        [_theDelegate wishToAward];
    }

}


@end
