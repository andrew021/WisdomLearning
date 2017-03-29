//
//  StudyHeadCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "StudyHeadCell.h"

@implementation StudyHeadCell

- (void)awakeFromNib {
    // Initialization code
    self.headerBtn.layer.cornerRadius = 80.0/2;
    self.headerBtn.layer.masksToBounds = YES;
    self.headerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerBtn.layer.borderWidth = 1.0f;
    _bgIv.image = [ThemeInsteadTool imageWithImageName:@"study_back"];
    
    self.signedBtn.layer.cornerRadius = 5.0f;
    self.signedBtn.layer.borderWidth = 1.0f;
}
- (IBAction)clickBtn:(UIButton *)sender {
    if(_delegate){
        [self.delegate clickStudyHeadCellBtn:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
