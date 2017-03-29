//
//  MHPhotoCollectionCell.h
//  图片浏览器
//
//  Created by LMH on 16/3/10.
//  Copyright © 2016年 LMH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTapImgView.h"
#import "MHPhotoModel.h"

@interface MHPhotoCollectionCell : UICollectionViewCell<UIScrollViewDelegate,MHTapImgViewDelegate>{
    CGRect frameRect;
}

@property(nonatomic,strong)MHTapImgView *photoView;
@property(nonatomic,strong)UIScrollView *imgScrollView;
@property(nonatomic,strong)UIActivityIndicatorView *loadingIndicator;

- (void)reloadCellWith:(MHPhotoModel*)photo;
@end
