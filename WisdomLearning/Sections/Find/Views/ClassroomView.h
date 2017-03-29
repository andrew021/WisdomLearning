//
//  ClassroomView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"


@protocol ClassroomViewDelegate <NSObject>

- (void)ClassroomViewWithClickBtns:(UIButton *)sender;
- (void)ClassroomViewWithNoticeTitle:(NSString *)title url:(NSString *)url;

@end

@interface ClassroomView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *pullImage;
@property(nonatomic, weak) IBOutlet LDProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property(nonatomic, weak) IBOutlet UIButton *headImageBtn;
@property(nonatomic, weak) IBOutlet UILabel *remaindingDaysLabel;
@property(nonatomic, weak) IBOutlet UILabel *dateLabel;
@property(nonatomic, weak) IBOutlet UILabel *sortNumLabel;
@property(weak, nonatomic) IBOutlet UIView *noticeView;
@property(weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *talkBtn;

//@property(nonatomic, strong) ZSOfflineClassInfo *classInfo;


@property (nonatomic, strong) OnLineClassDetail *detail;


@property (nonatomic, assign) id<ClassroomViewDelegate> delegate;

@end
