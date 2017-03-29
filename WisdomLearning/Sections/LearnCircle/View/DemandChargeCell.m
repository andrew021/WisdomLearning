//
//  DemandChargeCell.m
//  BigMovie
//
//  Created by hfcb001 on 16/2/22.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "DemandChargeCell.h"

@implementation DemandChargeCell

- (void)awakeFromNib {
    // Initialization code
    
}
+ (instancetype)cellWithTable:(UITableView *)tableView {
    DemandChargeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"demandChargeCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DemandChargeCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)clearData:(UIButton *)sender {
    if(_delegate){
        [self.delegate clearData:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
