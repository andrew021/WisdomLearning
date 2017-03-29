//
//  ForgetCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ForgetCell.h"

@interface ForgetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@end

@implementation ForgetCell

- (void)awakeFromNib {
    // Initialization code
    self.headerImage.layer.cornerRadius = 23.0f;
    self.headerImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
