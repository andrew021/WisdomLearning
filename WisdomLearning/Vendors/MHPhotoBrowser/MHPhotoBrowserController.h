//
//  MHPhotoBrowserController.h
//  图片浏览器
//
//  Created by LMH on 16/3/10.
//  Copyright © 2016年 LMH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPhotoModel.h"

@protocol DeleteImageForArray <NSObject>

-(void)delegateImageForArrayWith:(NSInteger)index;

@end

@interface MHPhotoBrowserController : UIViewController

@property (nonatomic,strong)NSMutableArray *imgArray;
@property (nonatomic,assign)NSInteger currentImgIndex;
@property (nonatomic,strong)id<DeleteImageForArray>delegate;

///是否显示顶部页码(显示顶部,则底部隐藏)
@property (nonatomic,assign) BOOL displayTopPage;

///是否显示删除按钮(默认不显示)
@property (nonatomic,assign) BOOL displayDeleteBtn;

///单击退出浏览
- (void)singleTapDetected;

@end
