//
//  ClassroomView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ClassroomView.h"
#import "UIButton+WebCache.h"

@implementation ClassroomView

-(void)awakeFromNib{
    self.pullImage.transform=CGAffineTransformMakeRotation(M_PI);
//    _dutyButton.layer.cornerRadius = 5.0f;
//    _dutyButton.layer.borderWidth = 1;
//    _dutyButton.layer.borderColor = kMainThemeColor.CGColor;
//    _headerImageView.layer.cornerRadius = 32.0;
//    _headerImageView.clipsToBounds = YES;
    
    
     [self.talkBtn  setImage:[ThemeInsteadTool imageWithImageName:@"group_chat"] forState:UIControlStateNormal];
    _progressView.flat = @YES;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.animate = @NO;
    _progressView.showText = @0;
    _progressView.color = kMainThemeColor;
    
    _progressLabel.textColor = kMainThemeColor;
    
    _scoreLabel.textColor = kMainThemeColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.noticeView addGestureRecognizer:tap];
}
-(void)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassroomViewWithNoticeTitle:url:)]) {
        [self.delegate ClassroomViewWithNoticeTitle:self.detail.noticeTitle url:self.detail.noticeListUrl];
    }
}

- (IBAction)clickImage:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ClassroomViewWithClickBtns:)]) {
        [self.delegate ClassroomViewWithClickBtns:sender];
    }
}

- (void)setDetail:(OnLineClassDetail *)detail
{
    _detail = detail;
    
    [self.headImageBtn sd_setBackgroundImageWithURL:[detail.clazzImg stringToUrl] forState:UIControlStateNormal placeholderImage:kPlaceDefautImage];
    
    self.progressView.progress = detail.progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%@",detail.progress * 100,@"%"];
    self.remaindingDaysLabel.text = [NSString stringWithFormat:@"%ld天",detail.byDaies];
    self.dateLabel.text = [NSString stringWithFormat:@"%@至%@",detail.classStartTime,detail.classEndTime];
    self.scoreLabel.text = [NSString stringWithFormat:@"%.f%@/%.f%@",detail.finishedScore, resunit,detail.totalScore, resunit];
    self.sortNumLabel.text = [NSString stringWithFormat:@"排名:No.%ld",detail.rank];
    if (detail.noticeTitle.length != 0) {
        self.noticeView.hidden = NO;
        self.noticeLabel.text = detail.noticeTitle;
    } else {
        self.noticeView.hidden = YES;
    }
    
}


- (IBAction)clickGroupChat:(UIButton *)sender {
    if(_delegate){
        [self.delegate ClassroomViewWithClickBtns:sender];
    }
}



@end
