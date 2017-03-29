//
//  LightAppModel.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightAppModel : NSObject

@property (nonatomic,copy) NSString * Id;//应用Id
@property (nonatomic,copy) NSString * name;//应用名称
@property (nonatomic,copy) NSString * img;//icon
@property (nonatomic,copy) NSString * subject;//应用简介
@property (nonatomic,copy) NSString * createDate;//发布时间
@property (nonatomic,assign) NSInteger type;//
@property (nonatomic,assign) BOOL owned;//是否添加

@end
