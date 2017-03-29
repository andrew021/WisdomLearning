//
//  ZSMessageGroupSettingModel.h
//  BigMovie
//
//  Created by DiorSama on 16/5/12.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSMessageGroupSettingModel : NSObject
//群ID
@property (nonatomic, strong)NSString * GP_ID;
//群名称
@property (nonatomic, strong)NSString * GP_NAME;
//群人数
@property (nonatomic, strong)NSString * GM_SIZE;
//群名片
@property (nonatomic, strong)NSString * GM_CARD;
//用户的群成员ID
@property (nonatomic, strong)NSString * GM_ID;
//0-普通群成员 1-群主 2-项目完成
@property (nonatomic, assign)NSInteger GM_TYPE;

@end
