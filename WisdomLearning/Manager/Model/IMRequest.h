//
//  IMRequest.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMRequestModel.h"
#import <Foundation/Foundation.h>

@interface IMRequest : NSObject

- (void)requestWithModel:(IMRequestModel*)model
                   block:(void (^)(ZSModel* model, NSError* error))block;

- (void)cancleRequest;

@end
