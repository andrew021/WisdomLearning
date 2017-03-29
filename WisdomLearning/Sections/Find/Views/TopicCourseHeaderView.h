//
//  TopicCourseHeaderView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCourseHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *courseImageView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *courseNameLabel;

@property (nonatomic, strong) OfflineCourseDetail *detailModel;

@end
