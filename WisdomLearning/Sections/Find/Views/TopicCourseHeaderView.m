//
//  TopicCourseHeaderView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "TopicCourseHeaderView.h"

@implementation TopicCourseHeaderView

-(void)awakeFromNib{
    _courseImageView.image = kPlaceDefautImage;
}

-(void)setDetailModel:(OfflineCourseDetail *)detailModel{
    _detailModel = detailModel;
    [_courseImageView sd_setImageWithURL:[detailModel.courseIcon stringToUrl] placeholderImage:kPlaceDefautImage];
    _timeLabel.text = [[detailModel.startDate add:@" "] add:detailModel.endDate];
    _locationLabel.text = detailModel.location;
    _courseNameLabel.text = detailModel.courseName;
}

@end
