//
//  SortUtil.m
//  BigMovie
//
//  Created by Shane on 16/4/28.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "SortUtil.h"

@implementation SortUtil

+ (void)sortData:(NSArray*)dataArray completionBlock:(void (^)(NSMutableArray*, NSMutableArray*))completionBlock
{
    NSMutableArray* titles = [NSMutableArray array];
    NSMutableArray* data = [NSMutableArray array];

    NSMutableArray* contactsSource = [NSMutableArray array];
    [contactsSource addObjectsFromArray:dataArray];

    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation* indexCollation = [UILocalizedIndexedCollation currentCollation];
    [titles addObjectsFromArray:[indexCollation sectionTitles]];

    NSInteger highSection = [titles count];
    NSMutableArray* sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray* sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }

    //按昵称首字母分组
    for (ZSMessageFriendListModel* model in contactsSource) {
        //设置了昵称的情况
        NSString* nickName = model.USER_SHORTNAME;
        NSString* firstLetter = [EaseChineseToPinyin pinyinFromChineseString:nickName];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        NSMutableArray* array = [sortedArray objectAtIndex:section];
        [array addObject:model];
    }

    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray* array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(ZSMessageFriendListModel* obj1, ZSMessageFriendListModel* obj2) {
            NSString* firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.USER_SHORTNAME];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];

            NSString* firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.USER_SHORTNAME];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];

            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }

    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray* array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [titles removeObjectAtIndex:i];
        }
    }

    [data addObjectsFromArray:sortedArray];
    completionBlock(titles, data);
}

@end
