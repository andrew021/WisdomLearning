//
//  RechargeCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RechargeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nunLabel;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UIButton *btn5;
@property (strong, nonatomic) IBOutlet UIButton *otherNumBtn;
@property (weak, nonatomic) IBOutlet UITextField *otherNumTf;
@property (weak, nonatomic) IBOutlet UILabel *moneyPayLabel;
@property (nonatomic, weak) IBOutlet UILabel *coinRuleLabel;

@property (nonatomic, copy)  NSString *moneyNum;

@property (nonatomic, copy) NSString *userLearnCoin;



@end
