//
//  UIViewController+ModifyPhoto.h
//  WisdomLearning
//
//  Created by Shane on 16/12/16.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChoosePhotoSucessBlock)(UIImage *photoChose);

@interface UIViewController (ModifyPhoto)<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(void)toChoosePhotoSucessBlock:(void (^)(UIImage *imageChoose))sucessBlock;

//imagepickercontroller  0 照相机  1相册
@property (nonatomic, copy) ChoosePhotoSucessBlock choosePhotoSucessBlock;

@end
