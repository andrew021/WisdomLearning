//
//  GroupsUtil.h
//  BigMovie
//
//  Created by Shane on 16/4/14.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GroupMemberListModel.h"
//#import "GroupModel.h"
#import "ZSMessageModel.h"
#import "Macro.h"


@interface GroupsManager : NSObject{
   
}

singleton_h(GroupsManager)


//获取群成员
-(void)groupMembersListWithGroupId:(NSString *)groupId completionBlock:(void (^)(NSArray *array))completionBlock;
//获取所有群
-(void)allGroupsWithUserId:(NSString *)userId completionBlock:(void (^)(NSArray *array))completionBlock;
//根据groupid获取gruopModel
-(ZSMessageGroupModel *)groupModelByGroupId:(NSString *)groupId;
//根据userId获取gruopMemberModel
//-(GroupMemberListModel *)groupMembrModelWithUserId:(long)userId;


@end
