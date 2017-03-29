//
//  SideslipSingle.h
//  WisdomLearning
//
//  Created by hfcb001 on 17/2/22.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SideslipSingle : NSObject

@property (nonatomic, assign) BOOL isSideslip;

+(SideslipSingle *) sharedInstance;

@end
