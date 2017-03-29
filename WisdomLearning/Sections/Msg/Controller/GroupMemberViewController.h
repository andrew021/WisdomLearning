//
//  GroupMemberViewController.h
//  BigMovie
//
//  Created by hfcb001 on 16/4/8.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    GroupTypeOwner,//创建者
    GroupTypeMember,//成员
}GroupMemberType;

@interface GroupMemberViewController : UIViewController

@property (strong, nonatomic) EMConversation *conversation;
@property (strong, nonatomic) NSArray * dataArray;
@property (strong, nonatomic) EMGroup *chatGroup;
@property (nonatomic) GroupMemberType occupantType;
@property (nonatomic,strong)NSString * owerId;
@property (nonatomic,strong)NSString * groupId;

@end
