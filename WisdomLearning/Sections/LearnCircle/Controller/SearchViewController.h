//
//  SearchViewController.h
//  BigMovie
//
//  Created by hfcb001 on 16/2/18.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SearchType) {
    SearchAll = 1,
    SearchCourse,
    SearchLearnCircle,
    SearchCertificate,
    SearchInformation,
    SearchSpecial
};

@interface SearchViewController : UIViewController

@property (nonatomic,assign)BOOL isTabbar;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)NSArray * keyArr;
@property (nonatomic, assign) SearchType type;


@end
