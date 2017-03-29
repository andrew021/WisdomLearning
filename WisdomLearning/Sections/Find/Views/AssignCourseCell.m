//
//  AssignCourseCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AssignCourseCell.h"

@implementation AssignCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_courseStatusButton setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCourseModel:(CourseList *)courseModel{
    _courseModel = courseModel;
    _courseNameLabel.text = _courseModel.courseName;
    _courseTimeLabel.text = [_courseModel.courseStartTime add:_courseModel.courseEndTime];
    NSString *status = @"未开始";
    if ([_courseModel.status integerValue] == 1) {
        status = @"已开始";
    }else if ([_courseModel.status integerValue] == 2){
        status = @"已结束";
    }
    [_courseStatusButton setTitle:status forState:UIControlStateNormal];
}

@end
