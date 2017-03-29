//
//  MsgListViewController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MsgType) {
    MsgGroup = 0,
    MsgPersonal,
    MsgSystem,
};

@interface MsgListViewController : UIViewController

@property (nonatomic, assign) MsgType type;

+ (instancetype)initWithType:(MsgType)type;
@end
