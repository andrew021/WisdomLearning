//
//  HomepageHeaderView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomepageHeaderViewDelegate <NSObject>

-(void) clickBackgroundImage;

@end

@interface HomepageHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *avaterImageView;
@property (nonatomic, weak) IBOutlet UILabel *friendLabel;
@property (nonatomic, weak) IBOutlet UILabel *nickLabel;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundIv;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) id<HomepageHeaderViewDelegate> theDelegate;

@property (nonatomic, copy) NSString *homeImageUrl;
@property (nonatomic, assign) BOOL isSelf;



@end
