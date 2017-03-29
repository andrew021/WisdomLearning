//
//  MsgManageViewController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSegmentController.h"
@interface MsgManageViewController : UIViewController

- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;



- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;
-(void)setRedPointView;

-(void)showWith:(EMMessage*)message;

@property (nonatomic,strong) UIImageView * leftImage;
@property (nonatomic,strong) UIImageView * midImage;
@property (nonatomic,strong) UIImageView * rightImage;
@end
