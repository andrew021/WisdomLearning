//
//  RechargeCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "RechargeCell.h"

extern float coinrule;

@interface RechargeCell()<UITextFieldDelegate>{
    NSArray<UIButton *> *moneyBtns;
}

@end

@implementation RechargeCell

- (void)awakeFromNib {
    NSString *coinruleText = [NSString stringWithFormat:@"(提示：1 元 = %.f 学币)", coinrule];
    _coinRuleLabel.text = coinruleText;
    
    moneyBtns = @[_btn1,_btn2,_btn3,_btn4,_btn5,_otherNumBtn];
 
    _moneyNum = @"50";
    
    _moneyNum = [NSString stringWithFormat:@"%.2f", [_moneyNum floatValue]/coinrule];
    _moneyPayLabel.text = [NSString stringWithFormat:@"总需支付：%@元", _moneyNum];
    
    _otherNumTf.delegate = self;
    
    for (int i = 0; i < 6; i++) {
        UIButton* unBtn = (UIButton*)moneyBtns[i];
        unBtn.layer.cornerRadius = 5;
        unBtn.layer.borderWidth = 1;
        if (_btn1 == unBtn) {
            unBtn.layer.borderColor = kMainThemeColor.CGColor;
            [unBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        }else{
            unBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            [unBtn setTitleColor:KMainBlack forState:UIControlStateNormal];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)clickBtn:(UIButton *)sender {
    if (sender == _otherNumBtn) {  //点击其他按钮
        sender.hidden = YES;
        _otherNumTf.hidden = NO;
        [_otherNumTf becomeFirstResponder];
        _otherNumTf.text = @"";
        
        [moneyBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *theBtn = (UIButton *)obj;
            if (theBtn != _otherNumBtn) {
                theBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
                [theBtn setTitleColor:KMainBlack forState:UIControlStateNormal];
            }
           
        }];
        
    }else{
        _otherNumBtn.hidden = NO;
        _otherNumTf.hidden = YES;
        [_otherNumTf resignFirstResponder];
        
        _moneyNum = [NSString stringWithFormat:@"%.2f", sender.tag/coinrule];
        _moneyPayLabel.text = [NSString stringWithFormat:@"总需支付：%@元", _moneyNum];
        
        
        sender.layer.borderColor = kMainThemeColor.CGColor;
        [sender setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        
        [moneyBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *theBtn = (UIButton *)obj;
            if (theBtn != sender) {
                theBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
                [theBtn setTitleColor:KMainBlack forState:UIControlStateNormal];

            }
        }];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     NSString *sss = [textField.text add:string];
    if ([string isEqualToString:@""]) {
        sss = [sss substringToIndex:sss.length-1];
    }
   
    NSString *ttt = [NSString stringWithFormat:@"%.2f", [sss floatValue]/coinrule];
    _moneyNum = ttt;
    _moneyPayLabel.text = [NSString stringWithFormat:@"总需支付：%@元", ttt];
    return YES;
}

-(void)setUserLearnCoin:(NSString *)userLearnCoin{
    _userLearnCoin = userLearnCoin;
    _nunLabel.text = [[@"学币余额：" add:_userLearnCoin] add:@"学币"];
}



@end
