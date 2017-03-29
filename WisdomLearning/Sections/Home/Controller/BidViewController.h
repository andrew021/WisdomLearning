//
//  BidViewController.h
//  BigMovie
//
//  Created by DiorSama on 16/4/25.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSSRichTextEditor.h"
//#import "UnLoginViewController.h"

@interface BidViewController : ZSSRichTextEditor

@property(nonatomic, copy) NSString *projectId;  //项目id
@property(nonatomic, copy) NSString *demandId; //需求id
@property (nonatomic,strong) id<ComDelegate>delegate;

@end
