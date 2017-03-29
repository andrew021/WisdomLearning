//
//  ZSCategoryListModel.m
//  WisdomLearning
//
//  Created by Shane on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSCategoryListModel.h"

@implementation ZSCategoryListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"data":[ZSCategoryInfo class] };
}

@end


@implementation ZSCategoryInfo

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"subs" : [ZSCategoryInfo class] };
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.busCount forKey:@"busCount"];
    [aCoder encodeObject:self.childCount forKey:@"childCount"];
    [aCoder encodeObject:self.subs forKey:@"subs"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.busCount = [aDecoder decodeObjectForKey:@"busCount"];
        self.childCount = [aDecoder decodeObjectForKey:@"childCount"];
        self.subs = [aDecoder decodeObjectForKey:@"subs"];
    }
    return self;
}

@end
