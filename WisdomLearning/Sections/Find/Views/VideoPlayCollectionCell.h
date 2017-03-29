//
//  VideoPlayCollectionCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZSImageTextButton;
@class ZSOnlineCourseDetail;

@interface VideoPlayCollectionCell : UICollectionViewCell

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
