//
//  MyOrderCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setList:(MyOrderformList *)list
{
    _list = list;
    
    self.titleLabel.text = list.name;
    self.dateLabel.text = list.createTime;
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",list.orderNo];
    self.moneyLabel.text = [[NSString stringWithFormat:@"金额：%g ",list.price] add:priceunit];
    [self.clickBtn setTitle:list.statusString forState:UIControlStateNormal];
    
    if (list.status == 1) {
//        [self.clickBtn setTitle:@"购买成功" forState:UIControlStateNormal];
        [self.clickBtn setTitleColor:KMainRed forState:UIControlStateNormal];
    } else if (list.status == 2){
//        [self.clickBtn setTitle:@"继续支付" forState:UIControlStateNormal];
        [self.clickBtn setTitleColor:KMainOrange forState:UIControlStateNormal];
    } else if (list.status == 3){
//        [self.clickBtn setTitle:@"已失效" forState:UIControlStateNormal];
        [self.clickBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    }
}

@end
