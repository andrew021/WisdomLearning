//
//  OrderConfirmCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "OrderConfirmCell.h"

@implementation OrderConfirmCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCourseIcon:(NSString *)courseIcon{
    _courseIcon = courseIcon;
    [_iconImageview sd_setImageWithURL:[courseIcon stringToUrl] placeholderImage:kPlaceDefautImage];
    
}

-(void)setCourseName:(NSString *)courseName{
    _courseName = courseName;
    _courseNameLabel.text = courseName;
}

-(void)setCoursePrice:(NSString *)coursePrice{
    _coursePrice = coursePrice;
    _coursePriceLabel.text = [[@"￥" add:coursePrice] add:@"元"];
}
@end
