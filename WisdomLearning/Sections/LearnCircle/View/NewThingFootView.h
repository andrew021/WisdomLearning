//
//  NewThingFootView.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/11.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewThingFootViewDelegate <NSObject>

-(void)clickBtns:(UIButton *)sender;

@end

@interface NewThingFootView : UIView

@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic,strong) id<NewThingFootViewDelegate> delegate;

@end
