//
//  AliPayManager.h
//  WisdomLearning
//
//  Created by Shane on 16/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPayManager : NSObject


@property(nonatomic, copy) NSString *orderNum;
@property(nonatomic, assign) BOOL fromAward;  //是否来自打赏

-(void)payWithSignedString:(NSString *)orderString andOrderNum:(NSString *)orderNum andFromAward:(BOOL)fromAward;

-(BOOL) handleOpenURL:(NSURL *) url;

+ (instancetype)sharedManager;

@end
