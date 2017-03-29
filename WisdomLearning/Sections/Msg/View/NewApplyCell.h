//
//  NewBuddyCell.h
//  BigMovie
//
//  Created by Shane on 16/4/11.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBaseTableViewCell.h"
#import "ZSButton.h"
#import "CellLongPressDelegate.h"
#import "ZSMessageNewFriendModel.h"

@protocol ClickBtnToAddOrReject <NSObject>

-(void)clickAddBtnWithIndex:(NSIndexPath *)index completionBlock:(void (^)())completionBlock;
-(void)clickRejectBtnWithIndex:(NSIndexPath *)index completionBlock:(void (^)())completionBlock;

@end
static CGFloat NewBuddyCellMinHeight  = 75.0f;
static NSString *NewBuddyCellIdentifier = @"NewApplyCell";

@interface NewApplyCell : kBaseTableViewCell

@property (nonatomic, strong) UILabel *lbNick,  *lbIntro;
@property (nonatomic, strong) UIView *view1, *view2;
@property (nonatomic, strong) UIImageView *ivAvatar;
@property (nonatomic, strong) ZSButton *btnAgree, *btnReject, *btnAlready;
@property (nonatomic, strong) UILabel *lbAlready;


@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, weak)id<ClickBtnToAddOrReject>delegate;
@property(nonatomic, weak) id<CellLongPressDelegate>longPressDelegate;
@property(nonatomic, strong)ZSMessageNewFriendModel * model;


@end
