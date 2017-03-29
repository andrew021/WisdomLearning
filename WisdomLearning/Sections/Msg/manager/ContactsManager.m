//
//  ContactsUtil.m
//  BigMovie
//
//  Created by Shane on 16/4/13.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "ContactsManager.h"
#import "UIHelper.h"
#import "Macro.h"

static ContactsManager *defaultManager = nil;
static char *queueContacts = "com.zhisou.contacts";

@interface ContactsManager(){
    dispatch_queue_t _queue;
}
@property (nonatomic, copy) NSArray *sortedAllContacts; //根据userId排序的好友列表
//@property (nonatomic, copy) ZSTrendHeader * zsModel;
@property (nonatomic, copy) NSMutableArray *allConversation;
@end

@implementation ContactsManager

singleton_m(ContactsManager)

-(instancetype)init{
    if (self = [super init]) {
        _queue = dispatch_queue_create(queueContacts, DISPATCH_QUEUE_SERIAL);
        _allConversation = [NSMutableArray new];
    }
    return self;
}

-(ZSIndividualDetail*)getLinkManModel:(NSString*)userId
{
    
  __block NSUInteger findIndex = 0;

    if (_allConversation== nil || _allConversation.count == 0) {
        return nil;
    }else{
        for(int i=0;i<_allConversation.count;i++){
            
            ZSIndividualDetail * model = _allConversation[i];
            if([userId isEqualToString:model.userId]){
                findIndex = i;
                
                return _allConversation[findIndex];
            }
            
        }
        return nil;
    }

 
   
}



-(void)getAllConversationCompletionBlock:(void (^)(NSMutableArray *array))completionBlock
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    for(int i=0;i<conversations.count;i++){
        ZSRequest * request = [[ZSRequest alloc]init];
        EMConversation *conversation = conversations[i];
        NSDictionary * dic = @{@"userId":conversation.conversationId};
        [request requestIndividalDetailtWith:dic withBlock:^(ZSIndividualDetailModel *model, NSError *error) {
            if(model.isSuccess){
                //排序
                if(model.data != nil){
                [_allConversation addObject:model.data];
                }
                    if (completionBlock) {
                        completionBlock(_allConversation);
                    }
                }  else{
                //NSLog(@"+WWWW+ %@",model.message);
                //[UIHelper alert:model.message completionBlock:nil];
            }
        }];

    }
    
}
//根据用户id获取数据model
-(ZSMessageFriendListModel *)contactModelByUserId:(NSString *)userId{
    __block NSUInteger findIndex = 0;
   
    if (_sortedAllContacts == nil || _sortedAllContacts.count == 0) {
        return nil;
    }else{
        for(int i=0;i<_sortedAllContacts.count;i++){
           
            ZSMessageFriendListModel * model = _sortedAllContacts[i];
            if([userId isEqualToString:model.USER_ID]){
                findIndex = i;
             
               return _sortedAllContacts[findIndex];
            }
           
        }
        return nil;
    }

}


//获取所有联系人
-(void)allContactsWithUserId:(NSString *)userId completionBlock:(void (^)(NSArray *))completionBlock{
    if (userId && userId.length > 0) {
        
        IMRequest * request = [[IMRequest alloc]init];
        [request requestFriendListPro_id:@"" dm_id:@"" block:^(ZSMessageFriendModel *model, NSError *error) {
            if(model.isSuccess){
                //排序
                @synchronized (self) {
               
                    _sortedAllContacts = [model.data
                                          sortedArrayUsingComparator:^NSComparisonResult(ZSMessageFriendListModel *model1, ZSMessageFriendListModel *model2) {
                        return [model1.USER_ID compare:model2.USER_ID];
                    }];
                }
                if (completionBlock) {
                    completionBlock(_sortedAllContacts);
                }
                
            }
            else{
              //  [UIHelper alert:model.message completionBlock:nil];
            }

        }];
                
    }
}

@end
