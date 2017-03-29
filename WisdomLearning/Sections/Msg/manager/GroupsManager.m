//
//  GroupsUtil.m
//  BigMovie
//
//  Created by Shane on 16/4/14.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "GroupsManager.h"
//#import "APIManager.h"


static GroupsManager *defaultManager = nil;
static char *queueGroups = "com.zhisou.groups";

@interface GroupsManager(){
    dispatch_queue_t _queue;
}

@property (nonatomic, copy) NSArray *sortedAllGroups; //根据groupid排序的群组
@property (nonatomic, copy) NSArray *sortedGroupMembers;//根据userid排序的群成员

@end

@implementation GroupsManager

singleton_m(GroupsManager)

-(instancetype)init{
    if (self = [super init]) {
        _queue = dispatch_queue_create(queueGroups, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
//
//-(void)groupMembersListWithGroupId:(NSString *)groupId completionBlock:(void (^)(NSArray *array))completionBlock{
//    [[APIManager sharedAPI]groupMembersListWithGroupid:groupId result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
//        if(success){
//            //排序
//            @synchronized (self) {
//                _sortedGroupMembers = [arrays sortedArrayUsingComparator:^NSComparisonResult(GroupMemberListModel *model1, GroupMemberListModel *model2) {
//                    NSNumber *value1 = @(model1.userId);
//                    NSNumber *value2 = @(model2.userId);
//                    return [value1 compare:value2];
//                }];
//            }
//            if (completionBlock) {
//                completionBlock(_sortedGroupMembers);
//            }
//        }
//        else{
//            [UIHelper alert:msg completionBlock:nil];
//        }
//    }];
//}

-(void)allGroupsWithUserId:(NSString *)userId completionBlock:(void (^)(NSArray *))completionBlock{
    if (userId && userId.length > 0) {
        IMRequest * request = [[IMRequest alloc]init];
        [request requestGroupListBlock:^(ZSMessageGroupListModel *model, NSError *error) {
            if (model.isSuccess) {
                @synchronized (self) {
                    //排序
                    _sortedAllGroups = [model.data sortedArrayUsingComparator:^NSComparisonResult(ZSMessageGroupModel *model1, ZSMessageGroupModel *model2) {
                        NSNumber *value1 = @([model1.GP_ID longLongValue]);
                        NSNumber *value2 = @([model2.GP_ID longLongValue]);
                        return [value1 compare:value2];
                    }];
                   
                }
                if (completionBlock) {
                    completionBlock(_sortedAllGroups);
                }
            }else{
               // [UIHelper alert:model.message completionBlock:nil];
            }

        }];
    }
}

-(ZSMessageGroupModel *)groupModelByGroupId:(NSString *)groupId{

    __block int findIndex = 0;
    if (_sortedAllGroups.count == 0) {
        return nil;
    }else{
        for(int i=0;i<_sortedAllGroups.count;i++){
            ZSMessageGroupModel * model = _sortedAllGroups[i];
            if([groupId isEqualToString:model.GP_ID]){
                findIndex = i;
                return _sortedAllGroups[findIndex];
            }
            
        }
        return nil;
    }
//    for(int i=0;i<_sortedAllGroups.count;i++){
//        ZSMessageGroupModel * model = _sortedAllGroups[i];
//        if([groupId isEqualToString:model.GP_ID]){
//            findIndex = i;
//        }
//        
//    }
//    return _sortedAllGroups[findIndex];
    
//    dispatch_sync(_queue, ^{
//        //查找
//        NSRange searchRange = NSMakeRange(0, [_sortedAllGroups count]);
//        findIndex = [_sortedAllGroups indexOfObject:groupId inSortedRange:searchRange options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            NSNumber *value1 = @([((ZSMessageGroupModel *)obj1).GP_NAME longLongValue]);
//            NSNumber *value2 = @([obj2 longLongValue]);
//            return [value1 compare:value2];
//        }];
//    });
//    return ((findIndex == NSNotFound) ? nil : _sortedAllGroups[findIndex]);
}

//-(GroupMemberListModel *)groupMembrModelWithUserId:(long)userId{
//    __block NSUInteger findIndex = -1;
//    dispatch_sync(_queue, ^{
//        //查找
//        NSRange searchRange = NSMakeRange(0, [_sortedGroupMembers count]);
//        findIndex = [_sortedGroupMembers indexOfObject:@(userId) inSortedRange:searchRange options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            NSNumber *value1 = @(((GroupMemberListModel *)obj1).userId);
//            NSNumber *value2 = @([obj2 longLongValue]);
//            return [value1 compare:value2];
//        }];
//    });
//    return ((findIndex == NSNotFound) ? nil : _sortedGroupMembers[findIndex]);
//}




@end
