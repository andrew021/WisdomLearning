//
//  InfoModel.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"
#import "InfoDetailModel.h"

@interface InfoModel : ZSModel

@property (nonatomic, strong) InfoDetailModel * data;

@end

@interface ZSMyCreditModel : ZSModel

@property (nonatomic, strong) NSArray<MyCreditModel*>* pageData;
@property (nonatomic, assign)long score;//当前分数
@property (nonatomic, assign) NSInteger curPage;//当前页数
@property (nonatomic, assign) NSInteger totalPages;//总页数

@end
