//
//  FindCircleController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindCircleController : UIViewController

@property (nonatomic,assign)BOOL isTabbarHide;
@property (nonatomic,assign)BOOL isSlideVC;

-(void)searchFetchData:(NSString*)key;

@end
