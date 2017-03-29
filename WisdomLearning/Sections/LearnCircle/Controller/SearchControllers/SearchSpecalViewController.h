//
//  SearchSpecalViewController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSpecalViewController : UIViewController

@property (nonatomic,strong) NSString * key;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,strong)id<ComDelegate>delegate;
-(void)searchFetchData;
@end
