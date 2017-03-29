//
//  VideoIntroCollectionCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoIntroCollectionCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UILabel *introLabel;
@property(nonatomic, copy) NSString *courseDesc;



@end
