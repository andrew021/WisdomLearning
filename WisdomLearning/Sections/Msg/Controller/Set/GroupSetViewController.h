//
//  GroupSetViewController.h
//  BigMovie
//
//  Created by hfcb001 on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    GroupOccupantTypeOwner,//创建者
    GroupOccupantTypeMember,//成员
}GroupOccupantType;

@protocol DeleteAllGroupMessages <NSObject>

-(void)deleteGroupMessages;

@end
@interface GroupSetViewController : UIViewController
@property (nonatomic,strong)NSString * accountStr;
@property (nonatomic,strong)NSMutableArray * messageArr;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong)NSString * groupName;
@property (nonatomic, strong) NSArray * data;
@property (nonatomic, strong) NSString * memberCount;
@property (nonatomic,assign)BOOL isMsg;
@property (nonatomic,weak) id<DeleteAllGroupMessages>delegate;
@end
