//
//  SSImageButton.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSImageButton;
@class SSImageObject;

@protocol SSImageButtonDelegate <NSObject>

@optional
- (void) didLoadImage:(SSImageButton *)imageButton didChangeImageSize:(CGSize)size;

@end

@interface SSImageButton : UIButton

@property(nonatomic, strong) SSImageObject *imageObject;
@property(nonatomic, weak) id<SSImageButtonDelegate> delegate;

@end
