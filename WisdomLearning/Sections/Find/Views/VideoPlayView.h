//
//  VideoPlayView.h
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSImageTextButton.h"



@class ZSImageTextButton;

@interface VideoPlayView : UIView


@property(nonatomic, strong) ZSImageTextButton *purchaseButton;
@property(nonatomic, weak) IBOutlet UIButton *chooseCourseButton;
@property(nonatomic, weak) IBOutlet UIView *videoView;
@property(nonatomic, weak) IBOutlet UILabel *courseNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *courseFromLabel;
@property(nonatomic, weak) IBOutlet UILabel *playNumLabel;
@property(nonatomic, weak) IBOutlet UILabel *coursePriceLabel;
@property(nonatomic, weak) IBOutlet UILabel *courseScoreLabel;
@property(nonatomic, weak) IBOutlet UILabel *branchNameLabel;

@property(nonatomic, assign) BOOL isPurchaseSucess;
@property(nonatomic, assign) BOOL isChooseCourseSucess;


@property(nonatomic, strong) ZSOnlineCourseDetail *courseDetail;

@end
