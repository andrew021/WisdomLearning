//
//  HomepageDynamicTextCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSIndividualDetailModel.h"

@interface HomepageDynamicTextCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UILabel *contentLabel;
@property(nonatomic, weak) IBOutlet UILabel *timeLabel;

@property(nonatomic, strong) ZSFreshInfo *info;

@end
