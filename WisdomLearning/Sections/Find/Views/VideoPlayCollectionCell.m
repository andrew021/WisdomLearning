//
//  VideoPlayCollectionCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "VideoPlayCollectionCell.h"
#import "ZSImageTextButton.h"
#import "ZSOnlineCourseDetail.h"


@implementation VideoPlayCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _purchaseButton = [[ZSImageTextButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, _chooseCourseButton.y, 80, 25) andImageLeft:YES andImage:[UIImage imageNamed:@"buy"] andTitle:@"点击购买" andTitleFont:[UIFont systemFontOfSize:12]];
//    _purchaseButton.titleFont = [UIFont systemFontOfSize:12];
    _purchaseButton.titleColor = [UIColor whiteColor];
    _purchaseButton.imageWidth = 15;
    _purchaseButton.imageHeight = 15;
    _purchaseButton.layer.cornerRadius = 5;
    _purchaseButton.layer.masksToBounds = YES;
    _purchaseButton.gap = 6;
    _purchaseButton.xPos = 5;
    _purchaseButton.tag = 2;
    _purchaseButton.hidden = YES;
    _purchaseButton.enabled = NO;
    [_purchaseButton setBackgroundColor:kMainThemeColor];
    [self.contentView addSubview:_purchaseButton];
    self.chooseCourseButton.layer.cornerRadius = 5;
    
    [self.chooseCourseButton setBackgroundColor:kMainThemeColor];
}


-(void)setCourseDetail:(ZSOnlineCourseDetail *)courseDetail{
    if (courseDetail == nil) {
        return ;
    }
    _courseNameLabel.text = courseDetail.courseName;
    _courseFromLabel.text = courseDetail.courseFrom;
    _playNumLabel.text = [[@"播放：" add:courseDetail.playNum] add:@"次"];

    _courseScoreLabel.attributedText = [[courseDetail.score add:@"学分"] takeString:@"学分" toColor:[UIColor colorWithHexString:@"ff8902"] isBefore:YES];
    
    if (courseDetail.learnFlag == YES ) {  //已经选课了
        _purchaseButton.hidden = YES;
        _purchaseButton.enabled = NO;
        _chooseCourseButton.hidden = YES;
        
        if (courseDetail.coursePrice != 0){
            _coursePriceLabel.hidden = NO;
            NSString *couresePrice = [NSString stringWithFormat:@"%g金币",courseDetail.coursePrice];
             _coursePriceLabel.attributedText = [couresePrice takeString:@"金币" toColor:[UIColor colorWithHexString:@"ff8902"] isBefore:YES];
        }else{
            _coursePriceLabel.hidden = YES;
        }
       
    }else{  //如果没有选课
        if (courseDetail.coursePrice == 0) {  //课程价格免费，则直接选课
            _coursePriceLabel.hidden = YES;
            _purchaseButton.hidden = YES;
            _purchaseButton.enabled = NO;
            
            _chooseCourseButton.hidden = NO;
            _chooseCourseButton.enabled = YES;
        }else{
            _coursePriceLabel.hidden = NO;
            NSString *couresePrice = [NSString stringWithFormat:@"%g金币",courseDetail.coursePrice];
            _coursePriceLabel.attributedText = [couresePrice takeString:@"金币" toColor:[UIColor colorWithHexString:@"ff8902"] isBefore:YES];
            
            
            _purchaseButton.hidden = NO;
            _purchaseButton.enabled = YES;
            
            _chooseCourseButton.hidden = YES;
            _chooseCourseButton.enabled = NO;
        }

    }
    
}

-(void)setIsPurchaseSucess:(BOOL)isPurchaseSucess{
    _isPurchaseSucess = isPurchaseSucess;
    if (isPurchaseSucess == YES) {
        _purchaseButton.hidden = YES;
        _purchaseButton.enabled = NO;
    }
}

-(void)setIsChooseCourseSucess:(BOOL)isChooseCourseSucess{
    _isChooseCourseSucess = isChooseCourseSucess;
    if (isChooseCourseSucess == YES) {
        _chooseCourseButton.hidden = YES;
        _chooseCourseButton.enabled = NO;
    }
}

@end
