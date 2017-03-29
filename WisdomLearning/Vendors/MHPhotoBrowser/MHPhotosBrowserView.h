//
//  MHPhotosBrowserView.h
//  图片浏览器
//
//  Created by LMH on 16/3/10.
//  Copyright © 2016年 LMH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHPhotosBrowserView;
@protocol MHPhotosBrowseDelegate <NSObject>
@optional
- (void)photosBrowse:(MHPhotosBrowserView *)photosBrowse didSelectItemAtIndex:(NSInteger)index;
- (void)photosBrowse:(MHPhotosBrowserView *)photosBrowse didClickDeleteBtnAtIndex:(NSInteger)index;
@end

@interface MHPhotosBrowserView: UIView<UICollectionViewDataSource,UIScrollViewAccessibilityDelegate,UICollectionViewDelegateFlowLayout>
{
    CGRect frameRect;
    
    UICollectionView *photoCollectionView;
    NSMutableArray *photoArray;
    int totalItemsCount;
    
    UILabel *pageNumberLabel;
    UILabel *pageTopNumLabel;
    NSTimer *autoScrollTimer;
    
    UIButton *deleteBtn;
}
@property (nonatomic,assign) BOOL displayDeleteBtn; //是否显示删除
@property (nonatomic,assign) BOOL displayTopPageNumber; //是否显示顶部页码
@property (nonatomic,assign) BOOL displayPageNumber; //是否显示右下角页码
@property (nonatomic,assign) CGFloat padding; //间隔

@property (nonatomic,assign) BOOL isInfiniteLoop; //是否无限循环
@property (nonatomic,assign) BOOL autoScroll;    //是否自动滚动
@property (nonatomic,assign) CGFloat autoScrollTimeInterval;

@property (nonatomic,assign)int currentImgIndex;    //移动到第几个图片 从1开始
@property (nonatomic, weak) id<MHPhotosBrowseDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame Photos:(NSMutableArray*)array;

- (void)reloadPhotoBrowseWithPhotoArray:(NSMutableArray*)array;

@end
