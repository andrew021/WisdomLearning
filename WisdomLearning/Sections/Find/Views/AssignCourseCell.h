//
//  AssignCourseCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignCourseCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *courseNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *courseTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *courseStatusButton;

@property (nonatomic, strong) CourseList *courseModel;

@end
