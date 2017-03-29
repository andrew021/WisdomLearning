//
//  ZSLoginModel.m
//  WisdomLearning
//
//  Created by Shane on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSLoginModel.h"

@implementation ZSLoginModel



@end


@implementation ZSLoginInfo

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.userIcon forKey:@"userIcon"];
    [aCoder encodeObject:self.mobileLearnTime forKey:@"mobileLearnTime"];
    [aCoder encodeObject:self.totalLearnTime forKey:@"totalLearnTime"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.learningScore forKey:@"learningScore"];
    [aCoder encodeObject:self.certificateNum forKey:@"certificateNum"];
    [aCoder encodeObject:self.learnCurrency forKey:@"learnCurrency"];
    
    [aCoder encodeObject:self.curLearnCourseNum forKey:@"curLearnCourseNum"];
    [aCoder encodeObject:self.curClassNum forKey:@"curClassNum"];
    [aCoder encodeObject:self.curProgramNum forKey:@"curProgramNum"];
    
    [aCoder encodeObject:self.collectCourseNum forKey:@"collectCourseNum"];
    [aCoder encodeObject:self.finishCourseNum forKey:@"finishCourseNum"];
    
    [aCoder encodeObject:self.finishClassNum forKey:@"finishClassNum"];
    [aCoder encodeObject:self.noticeNum forKey:@"noticeNum"];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.userIcon = [aDecoder decodeObjectForKey:@"userIcon"];
        self.mobileLearnTime = [aDecoder decodeObjectForKey:@"mobileLearnTime"];
        self.totalLearnTime = [aDecoder decodeObjectForKey:@"totalLearnTime"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        
        self.mobileLearnTime = [aDecoder decodeObjectForKey:@"mobileLearnTime"];
        self.totalLearnTime = [aDecoder decodeObjectForKey:@"totalLearnTime"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        
        self.learningScore = [aDecoder decodeObjectForKey:@"learningScore"];
        self.certificateNum = [aDecoder decodeObjectForKey:@"certificateNum"];
        self.learnCurrency = [aDecoder decodeObjectForKey:@"learnCurrency"];
        
        self.curLearnCourseNum = [aDecoder decodeObjectForKey:@"curLearnCourseNum"];
        self.curClassNum = [aDecoder decodeObjectForKey:@"curClassNum"];
        self.curProgramNum = [aDecoder decodeObjectForKey:@"curProgramNum"];
        
        self.collectCourseNum = [aDecoder decodeObjectForKey:@"collectCourseNum"];
        self.finishCourseNum = [aDecoder decodeObjectForKey:@"finishCourseNum"];
        self.finishClassNum = [aDecoder decodeObjectForKey:@"finishClassNum"];
        
        self.noticeNum = [aDecoder decodeObjectForKey:@"noticeNum"];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"noticeNum" : @"newNoticeNum"};
}

@end