//
//  SeeMoreView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/13.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeeMoreViewDelegate <NSObject>

-(void)seeMore:(NSIndexPath *)indexPath;

@end

@interface SeeMoreView : UIView

@property(nonatomic, weak) id<SeeMoreViewDelegate>  theDelegate;

@property(nonatomic, strong) NSIndexPath *currentIndexPath;

@end
