//
//  DynDetailsViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//  资讯详细

#import <UIKit/UIKit.h>
#import "ZSSRichTextEditor.h"
#import "Study.h"
#import "InfoDetailModel.h"

@interface DynDetailsViewController : UIViewController

@property (nonatomic,assign)BOOL isCreateImg;
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) DiscoveryInformation * infoModel;
@property (nonatomic,strong) InfoDetailModel * model;
@property (nonatomic,assign) NSInteger  type;

@end
