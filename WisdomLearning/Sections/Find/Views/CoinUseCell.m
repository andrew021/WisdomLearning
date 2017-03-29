//
//  CoinUseCell.m
//  WisdomLearning
//
//  Created by Shane on 16/11/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CoinUseCell.h"

@implementation CoinUseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isUseCoin = NO;
    
    _coninruleLabel.text = [NSString stringWithFormat:@"（1元=%.f学币）", coinrule];
//    [_selectButton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
//    [_selectButton setBackgroundImage:[UIImage imageNamed:@"gary_select"] forState:UIControlStateNormal];
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
- (IBAction)clickSelect:(UIButton *)sender {
    _isUseCoin = !_isUseCoin;
    if (_isUseCoin) {
        [_selectButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"selected"] forState:UIControlStateNormal];
    }else{
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"gary_select"] forState:UIControlStateNormal];
    }
    
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(useCoin:)]) {
        [_theDelegate useCoin:_isUseCoin];
    }
    
   //    sender.selected = !sender.selected;
//    _isUseCoin = !_isUseCoin;
}

@end
