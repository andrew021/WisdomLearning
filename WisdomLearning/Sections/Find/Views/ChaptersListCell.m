//
//  ChaptersListCell.m
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "ChaptersListCell.h"
#import "ZSCircleProgressView.h"

const CGFloat circleWidth = 35;

@implementation ChaptersListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _progressView  = [[ZSCircleProgressView alloc]initWithFrame:CGRectZero];
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(circleWidth));
        make.height.equalTo(@(circleWidth));
        make.centerY.equalTo(_studyStatusIv);
        make.right.equalTo(_studyStatusIv.mas_left).offset(-10);
    }];
    _progressView.arcFinishColor = kMainThemeColor;
    _progressView.arcUnfinishColor = kMainThemeColor;
    _progressView.arcBackColor = [UIColor colorWithHexString:@"EAEAEA"];
    _progressView.width = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCharpterInfo:(ZSChaptersInfo *)charpterInfo{
    _charpterInfo = charpterInfo;
    _chapterNameLabel.text = [NSString stringWithFormat:@"%@", charpterInfo.chapterName];
    _progressView.percent = [charpterInfo.learnCoverRate floatValue]/100;
}

-(void)setIsChoose:(BOOL)isChoose{
    _isChoose = isChoose;
    
    if (_isChoose) {
        _studyStatusIv.image = [ThemeInsteadTool imageWithImageName:@"studying"];
//        [self startAnimation];
    }else{
        _studyStatusIv.image = [ThemeInsteadTool imageWithImageName:@"start_study"];
//        CAAnimation *animation = [_percentIv.layer animationForKey:@"rotationAnimation"];
//        if (animation) {
//            [_percentIv.layer removeAnimationForKey:@"rotationAnimation"];
//        }
    }
}

//- (void)startAnimation
//{
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 1;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.removedOnCompletion = NO;
//    rotationAnimation.repeatCount = HUGE_VALF;
//    
//    [_percentIv.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//}

@end
