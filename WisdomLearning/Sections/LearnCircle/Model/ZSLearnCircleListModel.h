//
//  ZSLearnCircleListModel.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

//学习圈列表
@interface ZSLearnCircleListModel : NSObject

@property(nonatomic, copy) NSString * ID;//学习圈Id
@property(nonatomic, copy) NSString * name;//学习圈名称
@property(nonatomic, copy) NSString * img;//icon
@property(nonatomic, copy) NSString * area;//项目价格
@property(nonatomic, copy) NSString * tags;//标签
@property(nonatomic, copy) NSString * matchRate;//匹配度
@property(nonatomic, assign) int joinNum;//参加人数
@property(nonatomic, assign) int orderNum;//排名上升位数
@property(nonatomic, copy) NSString * createDate;//发布时间
@property(nonatomic, assign) BOOL joined;

@end

//同学录列表
@interface CLassMateListModel : NSObject

@property(nonatomic, copy) NSString * userId; //用户ID
@property(nonatomic, copy) NSString * userName;//用户名
@property(nonatomic, copy) NSString * userIcon;//用户缩略图
@property(nonatomic, copy) NSString * name;//
@property(nonatomic, copy) NSString * distance;//距离

@end

//搜索关键字
@interface SearchKeyArrModel : NSObject

@property(nonatomic, copy) NSString * keyword; //关键字
@property(nonatomic, copy) NSString * clickUrl;//链接地址

@end

//搜索关键字
@interface SearchKeyWordModel : NSObject

@property(nonatomic, copy) NSString * hotkeys; //热门搜索
@property(nonatomic, copy)NSString * mykeys;//历史搜索

@end

//测验结果
@interface WorkTestResultModel : NSObject

@property(nonatomic, copy) NSString * testId ; //测试ID
@property(nonatomic, copy) NSString * testName ; //测试名称
@property(nonatomic, copy) NSString * myscore ; //得分
@property(nonatomic, copy) NSString * totalScore ; //总分
@property(nonatomic, copy) NSString * answerMinutes ; //答题时长
@property(nonatomic, copy) NSString * totoalMinutes ; //总时长
@end


//测验试卷选项信息
@interface WorkTestItemsModel : NSObject

@property(nonatomic, copy) NSString * itemId ; //选项ID
@property(nonatomic, copy) NSString * itmeName ; //选项名称
@property(nonatomic, copy) NSString * sortOrder ; //排序顺序

@end

//测验试卷问题信息
@interface WorkTestQuestionsModel : NSObject

@property(nonatomic, copy) NSString * questionId ; //问题ID
@property(nonatomic, copy) NSString * questionName ; //问题名称
@property(nonatomic, copy) NSString * Typ ; //问题类型 1 单选题 2多选题 3问题提 4填空题
@property(nonatomic, copy) NSString * myAnswer ;
@property(nonatomic, copy) NSString * wholeAnswer ;
@property(nonatomic, copy) NSArray<WorkTestItemsModel*>* Items;

@end

//测验试卷信息
@interface WorkTestQuestionModel : NSObject

@property(nonatomic, copy) NSString * Totalminutes ; //选项ID
@property(nonatomic, copy) NSString * Score; //选项名称
@property(nonatomic, copy) NSArray<WorkTestQuestionsModel*>* questionList;//问题列表
@property(nonatomic, assign) BOOL isTested;//是否测试完成
@property(nonatomic, copy) NSString * testCount ; //选项ID

@end

//新鲜事
@interface NewThingModel : NSObject

@property(nonatomic, copy) NSString * Id ; //新鲜事id
@property(nonatomic, copy) NSString * userId ; //新鲜事来自的用户id
@property(nonatomic, copy) NSString * userName ;//新鲜事用户昵称
@property(nonatomic, copy) NSString * userIcon ;// 用户头像
@property(nonatomic, copy) NSString * content ;// 新鲜事内容
@property(nonatomic, copy) NSString * createTime ;//新鲜事创建时间
@property(nonatomic, copy) NSString * imgStr ;//新鲜事配图，多个之间用逗号分隔
@end

//新鲜事
@interface SystemSetModel : NSObject

@property(nonatomic, copy) NSString * configCode ; //新鲜事id
@property(nonatomic, copy) NSString * configName ; //新鲜事来自的用户id
@property(nonatomic, copy) NSString * configValue ;//新鲜事用户昵称


@end

//新鲜事
@interface SystemMsgModel : NSObject

@property(nonatomic, copy) NSString * content ; //内容
@property(nonatomic, copy) NSString * senderId ; //发送人Id
@property(nonatomic, copy) NSString * senderName ;//发送人名字
@property(nonatomic, copy) NSString * sendTime ; //发送时间
@property(nonatomic, copy) NSString * createTime ; //消息时间
@property(nonatomic, assign) BOOL readed ;//是否阅读
@property(nonatomic, assign) NSInteger type ;//消息类型
@property(nonatomic, copy) NSString * objectId ; //项目Id
@property(nonatomic, copy) NSString * courseId; //课程Id
@property(nonatomic, copy) NSString * programId; //专题Id
@property(nonatomic, copy) NSString * clazzId; //班级Id
@property(nonatomic, copy) NSString * newsId; //班级Id
@property(nonatomic, copy) NSString * testUrl; //班级Id
@property(nonatomic, copy) NSString * homeworkUrl;
@property(nonatomic, copy) NSString * ID;
@property(nonatomic, assign) NSInteger clazzType;

@end

//智能排序
@interface IntelligentOrderModel : NSObject

@property(nonatomic, copy) NSString * fieldCode; //排序字段代码
@property(nonatomic, copy) NSString * fieldName; //排序字段名称

@end

//智能筛选
@interface FilterFieldModel : NSObject

@property(nonatomic, copy) NSString * filterTypeName; //筛选类型名称
@property(nonatomic, copy) NSString * filterType; //筛选类型
@property(nonatomic, copy) NSString * filterTypeCode;//筛选类型代码
@property(nonatomic, assign) BOOL numbered;//是否是数值型
@property(nonatomic, copy) NSString * enumItems;//
@property(nonatomic, copy) NSString * enumCodes;

@end