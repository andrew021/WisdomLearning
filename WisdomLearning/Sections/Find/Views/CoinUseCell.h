//
//  CoinUseCell.h
//  WisdomLearning
//
//  Created by Shane on 16/11/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoinUseCellDelegate <NSObject>

-(void)useCoin:(BOOL)isUseCoin;

@end

@interface CoinUseCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *selectButton;
@property (nonatomic, weak) IBOutlet UILabel *coinLabel;
@property (nonatomic, weak) IBOutlet UILabel *coninruleLabel;
@property (nonatomic, weak) id<CoinUseCellDelegate> theDelegate;


@property (nonatomic, assign) BOOL isUseCoin;

@end
