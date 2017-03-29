//
//  HomeHeaderView.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "Study.h"

@protocol HomeHeaderViewDelegate <NSObject>

-(void)homeHeaderViewDelegateClickBtns:(UIButton *)sender;

@end

@interface HomeHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UIButton *talkBtn;
@property (weak, nonatomic) IBOutlet UILabel *organizeroLabel;
@property (weak, nonatomic) IBOutlet LDProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UIButton *signBtn;

@property (nonatomic, assign) id<HomeHeaderViewDelegate> delegate;
@property (nonatomic, strong) TopicsDetails *model;

@end
