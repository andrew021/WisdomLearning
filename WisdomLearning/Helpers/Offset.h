//
//  Offset.h
//  WisdomLearning
//
//  Created by hfcb001 on 17/1/16.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offset : NSObject

@property (nonatomic, assign) CGFloat offset;

+(Offset *) sharedInstance;

@end
