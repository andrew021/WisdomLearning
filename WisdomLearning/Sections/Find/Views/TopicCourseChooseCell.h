//
//  TopicCourseChooseCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCourseChooseCell : UITableViewCell


@property(nonatomic, weak) IBOutlet UIButton *selectButton;
@property(nonatomic, weak) IBOutlet UILabel *courseNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property(nonatomic, weak) IBOutlet UILabel *scoreLabel;

@property(nonatomic, strong) CourseList *course;


@end
