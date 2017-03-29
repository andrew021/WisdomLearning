//
//  LearnCircleDetailHeadView.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "Study.h"


@protocol LearnCircleDetailDelegate <NSObject>

-(void)clickBtns:(UIButton *)sender;

@end

@interface LearnCircleDetailHeadView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UIButton *talkBtn;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UIButton *signBtn;
@property (nonatomic,strong) id<LearnCircleDetailDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *createLabel;
@property (strong, nonatomic) IBOutlet UIImageView *riseImage;
@property (retain, nonatomic) LDProgressView * ldProgressView;
@property (nonatomic,strong) TopicsDetails * model;

@end
