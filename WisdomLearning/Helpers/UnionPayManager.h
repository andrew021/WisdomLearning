//
//  UnionPayManager.h
//  WisdomLearning
//
//  Created by Shane on 16/11/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnionPayManager : NSObject

-(BOOL) handleOpenURL:(NSURL *) url;

@property(nonatomic, copy) NSString *orderNum;
@property(nonatomic, assign) BOOL fromAward;  //是否来自打赏

+ (instancetype)sharedManager;


-(void)payWithSignedString:(NSString *)orderString andOrderNum:(NSString *)orderNum  andFromAward:(BOOL)fromAward andController:(UIViewController *)controller;

@end
