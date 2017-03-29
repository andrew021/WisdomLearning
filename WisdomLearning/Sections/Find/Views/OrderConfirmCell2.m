//
//  OrderConfirmCell2.m
//  WisdomLearning
//
//  Created by Shane on 17/2/23.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "OrderConfirmCell2.h"

@implementation OrderConfirmCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPrice:(NSString *)price{
    _priceLabel.text = [[@"￥" add:price] add:@"元"];
}

-(void)setCourseIcon:(NSString *)courseIcon{
    [_iconImageview sd_setImageWithURL:[courseIcon stringToUrl] placeholderImage:kPlaceDefautImage];
}

-(void)setDesc:(NSString *)desc{
    _descLabel.text = desc;
}

@end
