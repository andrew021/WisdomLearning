//
//  AddLightAppController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FetchDataLightApp <NSObject>

-(void)fetchDataGetLightApp;

@end

@interface AddLightAppController : UIViewController

@property (nonatomic,strong)id<FetchDataLightApp>delegate;

@end
