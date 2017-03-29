//
//  ChooseCourseCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/11.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ChooseCourseCell.h"
#import "LDProgressView.h"

@implementation ChooseCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    _progressView.color = [UIColor colorWithRed:63.0f/255.0f green:184.0f/255.0f blue:255.0f/255.0f alpha:1];
    _progressView.flat = @YES;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.progress = 0.70;
    _progressView.animate = @NO;
    _progressView.showText = @0;
    _progressView.color = kMainThemeColor;
    
    _images = @[@"rate0",@"rate1",@"rate2",@"rate3",@"rate4",@"rate5",];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCurriculum:(ZSCurriculumInfo *)curriculum{
    _curriculum = curriculum;
    [self.courseIcon sd_setImageWithURL:[curriculum.courseIcon stringToUrl] placeholderImage:kPlaceDefautImage];
    self.courseName.text = curriculum.courseName;
    if (curriculum.coursePrice == 0) {
        self.coursePrice.text = @"免费";
    }else{
        self.coursePrice.text = [NSString stringWithFormat:@"%g%@",curriculum.coursePrice, priceunit];
    }
    
    if (curriculum.learnNum != nil) {
        self.learnNum.text = [curriculum.learnNum add:@"人选课"];
    }else{
        self.learnNum.hidden = YES;
    }
    
    if (curriculum.learned == YES) {
        self.scoreLabel.hidden = YES;
        self.createTime.hidden = YES;
        
        self.progressView.hidden = NO;
        self.progressLabel.hidden = NO;
        self.remaindTimeLabel.hidden = NO;
        
        _progressView.progress = [curriculum.finishedPercent floatValue]/100;
        _progressLabel.text = [curriculum.finishedPercent add:@"%"];
        if (curriculum.remindTime != nil && curriculum.remindTime.length != 0) {
            _remaindTimeLabel.hidden = NO;
            _remaindTimeLabel.text = [[@"还需" add: curriculum.remindTime] add:@"分钟"];
        }else{
            _remaindTimeLabel.hidden = YES;
        }
        
        
    }else{
        self.progressView.hidden = YES;
        self.progressLabel.hidden = YES;
        self.remaindTimeLabel.hidden = YES;
        
        self.scoreLabel.hidden = NO;
        self.createTime.hidden = NO;
        
        self.scoreLabel.text = curriculum.cats;
        self.createTime.text = [curriculum.chapterNum add:@"节"];
    }
    
    
    
    [self.courseRating setImage:[UIImage imageNamed:_images[curriculum.rate]]];
    
}

@end
