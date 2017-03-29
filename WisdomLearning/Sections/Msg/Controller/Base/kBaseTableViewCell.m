//
//  UIBaseCell.m
//  BigMovie
//
//  Created by Shane on 16/4/11.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "kBaseTableViewCell.h"

@implementation kBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(id)cellForTableView:(UITableView *)tableView{
    NSString *identifier = [[self class] cellIdentifierWithModel:nil];
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

@end
