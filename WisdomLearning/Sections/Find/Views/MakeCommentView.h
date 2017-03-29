//
//  MakeCommentView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MakeCommentViewDelegate <NSObject>

-(void)wishToComment;
-(void)wishToAward;

@end

@class ZSImageTextButton;

@interface MakeCommentView : UIView<UITextFieldDelegate>

@property(nonatomic, strong)  UITextField *theCommentTf;
@property(nonatomic, weak) id<MakeCommentViewDelegate> theDelegate;

@property(nonatomic, assign) BOOL needReward;

@property(nonatomic, copy) void (^clickTfBlock)();

@end
