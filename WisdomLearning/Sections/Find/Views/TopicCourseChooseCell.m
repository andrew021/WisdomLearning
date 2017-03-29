//
//  TopicCourseChooseCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "TopicCourseChooseCell.h"

#define CELL_Y_OFFSET  10
#define CELL_X_OFFSET  10

@implementation TopicCourseChooseCell



- (void)awakeFromNib {
    [super awakeFromNib];
//    self.layer.borderWidth = 1;
//    self.layer.cornerRadius = 6;
//    self.layer.borderColor = [UIColor colorWithHexString:@"d8d8d8"].CGColor;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
//    self.descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    // Initialization code
    
//    [_selectButton setImage:[UIImage imageNamed:@"gary_select"] forState:UIControlStateNormal];
//    [_selectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    self.currencyLabel.textColor = kMainOrange;
    self.scoreLabel.textColor = kMainOrange;
}

-(void)setCourse:(CourseList *)course{
    _course = course;
    _courseNameLabel.text = course.courseName;
    
    _currencyLabel.text = [NSString stringWithFormat:@"%g%@",course.learnCurrency,priceunit];

    _scoreLabel.text = [NSString stringWithFormat:@"%g%@",course.score, resunit];
    
}


//- (IBAction)clickChoose:(UIButton *)sender {
//    sender.selected = !sender.selected;
//}

@end
