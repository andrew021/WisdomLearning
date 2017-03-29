//
//  ZSReplyListModel.h
//  WisdomLearning
//
//  Created by Shane on 16/11/3.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"


//"conditions": "",
//"curPage": 1,
//
//"perPage": 10,
//"totalPages": 1,
//"totalRecords": 2

@class ZSReplyListInfo;
@interface ZSReplyListModel : ZSModel

@property(nonatomic, copy) NSString *conditions;
@property(nonatomic, assign) long curPage;
@property(nonatomic, assign) long perPage;
@property(nonatomic, assign) long totalPages;
@property(nonatomic, assign) long totalRecords;
@property(nonatomic, copy) NSArray<ZSReplyListInfo *> *pageData;

@end

@interface ZSReplyInfo : NSObject

//private Long userId;
//private String userName;
//private String userIcon; // 用户头像
//private int commentScore;// 评价星级
//private String content;// 内容
//private String createTime;// 时间
//private String parentId;//父评论id
//private String replyerId;//回复人id
//private String replyerName;//回复人姓名
//private List<CommentVO> replyList;//回复列表

@property(nonatomic, copy) NSString *commentScore;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *parentId;
@property(nonatomic, copy) NSString *replyerId;
@property(nonatomic, copy) NSString *replyerName;
@property(nonatomic, copy) NSString *userIcon;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userName;

@end

@interface ZSReplyListInfo : NSObject

@property(nonatomic, copy) NSString *commentScore;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *parentId;
@property(nonatomic, copy) NSString *replyerId;
@property(nonatomic, copy) NSString *replyerName;
@property(nonatomic, copy) NSString *userIcon;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, strong) NSArray<ZSReplyInfo *> *replyList;

@end
