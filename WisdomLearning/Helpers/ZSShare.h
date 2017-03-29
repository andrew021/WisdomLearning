//
//  ZSShare.h
//  WisdomLearning
//
//  Created by Shane on 16/10/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSShare : NSObject

+(void)showShare:(id)sender;

+(void)platShareView:(UIView *)view WithShareContent:(NSString *)shareContent WithShareUrlImg:(NSString *)shareUrlImg WithShareUrl:(NSString *)shareUrl WithShareTitle:(NSString *)shareTitle;

@end
