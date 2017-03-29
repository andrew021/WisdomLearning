//
//  DoingCurriculumCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "DoingCurriculumCell.h"
#import "LDProgressView.h"

@implementation DoingCurriculumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _ldProgressView.color = kMainThemeColor;
    
    _ldProgressView.flat = @YES;
    _ldProgressView.showBackgroundInnerShadow = @NO;
    _ldProgressView.progress = 0.70;
    _ldProgressView.animate = @NO;
    _ldProgressView.showText = @0;
    
    [_cancelButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"cancel_choose"] forState:UIControlStateNormal];
    
    _percentLabel.textColor = kMainThemeColor;
    
   
}

-(void)setMyCourse:(ZSMyCourseInfo *)myCourse{
    _myCourse = myCourse;
    [_courseIconView sd_setImageWithURL:[myCourse.courseIcon stringToUrl] placeholderImage:kPlaceDefautImage];
    _coursenameLabel.text = myCourse.courseName;
    if (_type == 1) {
        _remaindingtimeLabel.text = [[@"还需" add:myCourse.remindTime] add:@"分钟"];
    }else{
        _remaindingtimeLabel.text = [@"完成时间：" add: myCourse.finishedTime];
    }
    
    _ldProgressView.progress = [myCourse.finishedPercent floatValue];
    _percentLabel.text = [NSString stringWithFormat:@"%.f%@",[myCourse.finishedPercent floatValue]*100,@"%"];
}

-(void)setType:(int)type{
    _type = type;
    if (_type == 3) {
        _percentLabel.hidden = YES;
        _ldProgressView.hidden = YES;
        _ldProgressView.userInteractionEnabled = NO;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
