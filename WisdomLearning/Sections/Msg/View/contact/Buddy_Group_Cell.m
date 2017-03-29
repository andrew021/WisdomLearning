//
//  GroupCell.m
//  BigMovie
//
//  Created by Shane on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "Buddy_Group_Cell.h"

@implementation Buddy_Group_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithModel:(id)model{
    return Buddy_Group_CellMinHeight;
}

+(NSString *)cellIdentifierWithModel:(id)model{
    return Buddy_Group_CellIdentifier;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.ivGroup.layer.cornerRadius = ViewHeight(self.ivGroup)/2;
    self.ivGroup.clipsToBounds = YES;
}

@end
