//
//  AwardView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AwardViewDelegate <NSObject>

-(void)awardWithPayWay:(NSString *)payWay andMoneyNum:(NSString *)moneyNum;

@end

@interface AwardView : UIView

@property(nonatomic, weak) IBOutlet UIView *bgView;

@property(nonatomic, weak) IBOutlet UIButton *oneBtn;
@property(nonatomic, weak) IBOutlet UIButton *twoBtn;
@property(nonatomic, weak) IBOutlet UIButton *fiveBtn;
@property(nonatomic, weak) IBOutlet UIButton *sixBtn;
@property(nonatomic, weak) IBOutlet UIButton *tenBtn;
@property(nonatomic, weak) IBOutlet UIButton *otherBtn;
@property(nonatomic, weak) IBOutlet UIButton *awardBtn;
@property(nonatomic, weak) IBOutlet UITextField *otherTf;

@property (nonatomic, weak) IBOutlet UIButton *payButton1;
@property (nonatomic, weak) IBOutlet UIButton *payButton2;
@property (nonatomic, weak) IBOutlet UIButton *payButton3;


@property(nonatomic, weak) id<AwardViewDelegate> theDelegate;




@end
