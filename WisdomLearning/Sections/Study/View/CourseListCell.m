//
//  CourseListCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CourseListCell.h"

@implementation CourseListCell

- (void)awakeFromNib {
    // Initialization code
}

//-(void)setModel:(CertificateCourseModel *)model
//{
//    _model = model;
//    NSDictionary * dic =model;
//  
//    self.nameLabel.text = [dic objectForKey:@"courseName"];
//   // self.courseLabel.text = [dic objectForKey:@"score"];
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
