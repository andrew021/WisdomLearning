//
//  SearchCoursrViewController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SearchCoursrViewController : UIViewController

@property (nonatomic,strong) NSString * key;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,strong)id<ComDelegate>delegate;

-(void)searchFetchData;

@end
