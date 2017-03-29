//
//  HomeHeaderView.m
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView

-(void)awakeFromNib
{
    self.avatarImage.layer.cornerRadius = 64/2.0;
    self.avatarImage.layer.masksToBounds = YES;
    
    self.talkBtn.layer.cornerRadius = 5.0;
    self.talkBtn.clipsToBounds = YES;
    self.talkBtn.backgroundColor = kMainThemeColor;
    self.talkBtn.tag = 1;
    
    _progressView.flat = @YES;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.animate = @NO;
    _progressView.showText = @0;
    _progressView.color = kMainThemeColor;
    
    _progressLabel.textColor = kMainThemeColor;
    
    _rankLabel.textColor = kMainThemeColor;
    
    self.signBtn.layer.cornerRadius = 5;
    self.signBtn.layer.borderWidth = 1;
    self.signBtn.tag = 2;
     [self.talkBtn  setImage:[ThemeInsteadTool imageWithImageName:@"group_chat"] forState:UIControlStateNormal];
}

- (void)setModel:(TopicsDetails *)model
{
    _model = model;
    [self.backImage sd_setImageWithURL:[model.image stringToUrl] placeholderImage:kPlaceDefautImage];
    [self.avatarImage sd_setImageWithURL:[self.model.createrAvater stringToUrl] placeholderImage:KPlaceHeaderImage];
    self.organizeroLabel.text = @"组织者";
    self.creditLabel.text = model.creater;
    

    if (model.sign) {
        self.signBtn.layer.borderColor = KMainTextGray.CGColor;
        [self.signBtn setTitleColor:KMainTextGray forState:UIControlStateNormal];
        [self.signBtn setTitle:@"已签" forState:UIControlStateNormal];
        self.signBtn.enabled = NO;
    } else {
        self.signBtn.layer.borderColor = kMainThemeColor.CGColor;
        [self.signBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        [self.signBtn setTitle:@"签到" forState:UIControlStateNormal];
        self.signBtn.enabled = YES;
    }
    
    self.progressView.progress = model.progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%@",model.progress *100, @"%"];
    self.endLabel.text = [NSString stringWithFormat:@"%ld节课",model.remainCourseNums];
    self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",model.openStartTime,model.openEndTime];
    self.rankLabel.text = [NSString stringWithFormat:@"%ld%@/%ld%@",model.finishedScore,resunit,model.scoreNeed, resunit];
    self.numLabel.text = [NSString stringWithFormat:@"排名：No.%ld",model.rank];
}

- (IBAction)groupChat:(id)sender {
    if (_delegate) {
        [self.delegate homeHeaderViewDelegateClickBtns:sender];
    }
}
- (IBAction)signClick:(id)sender {
    if (_delegate) {
        [self.delegate homeHeaderViewDelegateClickBtns:sender];
    }
}



@end
