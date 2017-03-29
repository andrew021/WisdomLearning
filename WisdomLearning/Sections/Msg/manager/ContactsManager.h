//
//  ContactsUtil.h
//  BigMovie
//
//  Created by Shane on 16/4/13.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "Macro.h"
#import <Foundation/Foundation.h>
#import "ZSIndividualDetailModel.h"

@interface ContactsManager : NSObject

singleton_h(ContactsManager)

//根据用户id获取数据model
- (ZSMessageFriendListModel*)contactModelByUserId : (NSString*)userId;

//获取所有联系人
- (void)allContactsWithUserId:(NSString*)userId completionBlock:(void (^)(NSArray* array))completionBlock;

-(ZSIndividualDetail*)getLinkManModel:(NSString*)userId;


-(void)getAllConversationCompletionBlock:(void (^)(NSMutableArray *array))completionBlock;
@end
