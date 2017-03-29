//
//  TestResultPopView.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickTestResultPopViewBtn <NSObject>

-(void)clickTestResultPopViewBtn:(UIButton*)btn;

@end

@interface TestResultPopView : UIView

@property (nonatomic,strong)id<ClickTestResultPopViewBtn>delegate;
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)title subTitle:(NSString *)subTitle image:(UIImage*)image;

@end
