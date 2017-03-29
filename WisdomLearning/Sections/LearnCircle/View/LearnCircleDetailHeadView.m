//
//  LearnCircleDetailHeadView.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "LearnCircleDetailHeadView.h"

@implementation LearnCircleDetailHeadView
- (void)awakeFromNib
{
    self.avatarImage.layer.cornerRadius = 64/2;
    self.avatarImage.layer.masksToBounds = YES;
  
    self.talkBtn.layer.cornerRadius = 5;
    self.talkBtn.backgroundColor = kMainThemeColor;
    self.talkBtn.tag = 1;
    
   _ldProgressView = [[LDProgressView alloc] initWithFrame:CGRectMake(15, 260, SCREEN_WIDTH-90, 13)];
 
    _ldProgressView.color = [UIColor colorWithRed:63.0f/255.0f green:184.0f/255.0f blue:255.0f/255.0f alpha:1];
   
   
    _ldProgressView.flat = @YES;
    _ldProgressView.showBackgroundInnerShadow = @NO;
   // ldProgressView.progress = 0.40;
    _ldProgressView.animate = @YES;
    _ldProgressView.showText = @"";
    [self addSubview:_ldProgressView];
 
    self.signBtn.layer.cornerRadius = 5;
    self.signBtn.layer.borderColor = kMainThemeColor.CGColor;
    self.signBtn.layer.borderWidth = 1;
    self.signBtn.tag = 2;
    
    
 

    
}

-(void)setModel:(TopicsDetails *)model
{
    _model = model;
    [self.backImage sd_setImageWithURL:[model.image stringToUrl]  placeholderImage:kPlaceDefautImage];
   
    self.createLabel.text = model.creater;
    [self.avatarImage sd_setImageWithURL:[_model.createrAvater stringToUrl] placeholderImage:KPlaceHeaderImage];
    
    NSString * str = [NSString stringWithFormat:@"火热排名 No%ld",model.rank];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:KMainTextGray
     
                          range:NSMakeRange(0, 4)];
    
    _rankLabel.attributedText = AttributedStr;
    if(model.rankType == 1){
        _numLabel.text =  [NSString stringWithFormat:@"上升 %ld位",model.changeRank];
    }
    else if(model.rankType == 2){
        _numLabel.text =  [NSString stringWithFormat:@"下降 %ld位",model.changeRank];
    }else{
        //_numLabel.text =  @"上升 %ld位";
        _numLabel.hidden = YES;
        _riseImage.hidden = YES;
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%ld分钟",model.totalStudytime/60];
    _ldProgressView.progress = model.progress;

    _progressLabel.text = [NSString stringWithFormat:@"%.f%@",model.progress*100,@"%"];
    _creditLabel.text = [NSString stringWithFormat:@"%ld%@/%ld%@",model.finishedScore, resunit,model.scoreNeed, resunit];
    
    if(model.isSigned){
        _signBtn.enabled = NO;
        [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        self.signBtn.layer.borderColor = KMainLine.CGColor;
        
    }
    else{
        _signBtn.enabled = YES;
        [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
        self.signBtn.layer.borderColor = kMainThemeColor.CGColor;
        [self.signBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];

    }
    
    if(model.changeRank>0){
        self.riseImage.image = [UIImage imageNamed:@"rise"];
    }
    else if(model.changeRank == 0){
        self.riseImage.image = [UIImage imageNamed:@""];
    }
    else{
        self.riseImage.image = [UIImage imageNamed:@"arrow_down"];
    }
    

    
}
- (IBAction)clickToTalk:(UIButton *)sender {
    if(_delegate){
        [self.delegate clickBtns:sender];
    }
    
}

- (IBAction)clickToSign:(UIButton *)sender {
    if(_delegate){
        [self.delegate clickBtns:sender];
    }
}

@end
