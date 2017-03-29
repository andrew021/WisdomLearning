//
//  PriceLeftCell.m
//  ACMilan
//
//  Created by DiorSama on 2016/12/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "PriceLeftCell.h"

@implementation PriceLeftCell

- (void)awakeFromNib {
    // Initialization code
    self.lineView.backgroundColor = KMainLine;
   // self.arrowsImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 6, 9)];
    //self.arrowsImg.image = [UIImage imageNamed:@"arrows_gray"];
    //[self.titleBtn addSubview:self.arrowsImg];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
