//
//  AwardView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AwardView.h"

@interface AwardView(){
    NSArray <UIButton *> *moneyBtns;
    NSArray <UIButton *> *payBtns;
    
    NSString *moneyNum;
    NSString *payWay;
}

@end

@implementation AwardView

-(void)awakeFromNib{
    if (payPaths.count != 0) {
        payWay = payPaths[0];
    }
    if (payPaths.count == 0) {
        payBtns = @[];
        _payButton1.hidden = YES;
        _payButton1.enabled = NO;
        
        _payButton2.hidden = YES;
        _payButton2.enabled = NO;
        
        _payButton3.hidden = YES;
        _payButton3.enabled = NO;
        
        
    }else if (payPaths.count == 1){
        _payButton2.tag = 0;
        payBtns = @[_payButton2];
        
        _payButton1.hidden = YES;
        _payButton1.enabled = NO;
        
        _payButton3.hidden = YES;
        _payButton3.enabled = NO;
        
        
    }else if (payPaths.count == 2){
        _payButton1.tag = 0;
        _payButton3.tag = 1;
        payBtns = @[_payButton1, _payButton3];
        
        _payButton2.hidden = YES;
        _payButton2.enabled = NO;
        
    }else if (payPaths.count == 3){
        _payButton1.tag = 0;
        _payButton2.tag = 1;
        _payButton3.tag = 2;
        payBtns = @[_payButton1, _payButton2, _payButton3];
    }
    
    for (int i = 0; i < payPaths.count; ++i) {
        NSString *payPath = payPaths[i];
        NSString *title = @"";
        if ([payPath isEqualToString:@"ali"]) {
            title = @"支付宝支付";
        }else if ([payPath isEqualToString:@"wx"]){
            title = @"微信支付";
        }else if ([payPath isEqualToString:@"union"]){
            title = @"银联支付";
        }
        [payBtns[i] setTitle:title forState:UIControlStateNormal];
    }
    

    _bgView.layer.cornerRadius = 10;
    moneyBtns = @[_oneBtn, _twoBtn, _fiveBtn, _sixBtn, _tenBtn, _otherBtn];
    [moneyBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *theBtn = (UIButton *)obj;
        theBtn.layer.borderWidth = 1;
        theBtn.layer.cornerRadius = 6;
        theBtn.layer.borderColor = [UIColor colorWithHexString:@"fe6731"].CGColor;
        [theBtn setTitleColor:[UIColor colorWithHexString:@"fe6731"] forState:UIControlStateNormal];
    }];
    
    _otherBtn.hidden = NO;
    _otherTf.hidden = YES;
    
    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tp];
    
    [payBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *theBtn = (UIButton *)obj;
        [theBtn addTarget:self action:@selector(clickPayWay:) forControlEvents:UIControlEventTouchUpInside];
        if (idx != 0) {
            [theBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
     }];
}


-(void)tap:(UITapGestureRecognizer *)tr{
    [Tool hideKeyBoard];
}


- (IBAction)clickMoney:(UIButton *)sender {
    if (sender == _otherBtn) {  //点击其他按钮
        sender.hidden = YES;
        _otherTf.hidden = NO;
        [_otherTf becomeFirstResponder];
        _otherTf.text = @"";
        
        [moneyBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *theBtn = (UIButton *)obj;
            theBtn.layer.borderWidth = 1;
            theBtn.layer.borderColor = [UIColor colorWithHexString:@"fe6731"].CGColor;
            [theBtn setTitleColor:[UIColor colorWithHexString:@"fe6731"] forState:UIControlStateNormal];
            [theBtn setBackgroundColor:[UIColor whiteColor]];
        }];
        
    }else{
        _otherBtn.hidden = NO;
        _otherTf.hidden = YES;
        [_otherTf resignFirstResponder];
        
        moneyNum = [NSString stringWithFormat:@"%ld", sender.tag];
        
        sender.layer.borderWidth = 0;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor grayColor]];
        
        [moneyBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *theBtn = (UIButton *)obj;
            if (theBtn != sender) {
                theBtn.layer.borderWidth = 1;
                theBtn.layer.borderColor = [UIColor colorWithHexString:@"fe6731"].CGColor;
                [theBtn setTitleColor:[UIColor colorWithHexString:@"fe6731"] forState:UIControlStateNormal];
                [theBtn setBackgroundColor:[UIColor whiteColor]];
            }
        }];
    }
}

- (void)clickPayWay:(UIButton *)sender {
    [sender setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    payWay = payPaths[sender.tag];
    [payBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *theBtn = (UIButton *)obj;
        if (theBtn != sender) {
            [theBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }];

}


- (IBAction)clickAward:(UIButton *)sender {
    if (_otherTf.isHidden == NO) {
        moneyNum = _otherTf.text;
    }
    
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(awardWithPayWay:andMoneyNum:)]) {
        if (payWay != nil && payWay.length != 0) {
            [_theDelegate awardWithPayWay:payWay andMoneyNum:moneyNum];
        }
        
    }
}

@end
