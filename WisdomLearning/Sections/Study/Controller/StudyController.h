//
//  StudyController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
// 学习 主界面

#import <UIKit/UIKit.h>

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_4G= 3,
    NETWORK_TYPE_5G= 4,//  5G目前为猜测结果
    NETWORK_TYPE_WIFI= 5,
}NETWORK_TYPE;

@interface StudyController : UIViewController

@end
