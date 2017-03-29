//
//  HomepageDynamicTextImagesCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSHorThreeImagesView.h"

@interface HomepageDynamicTextImagesCell : UICollectionViewCell

//@property(nonatomic, strong) IBOutlet ZSHorThreeImagesView *imagesView;

@property(nonatomic, weak) IBOutlet UILabel *contentLabel;
@property(nonatomic, weak) IBOutlet UILabel *timeLabel;

@property(nonatomic, strong) ZSFreshInfo *info;

@end
