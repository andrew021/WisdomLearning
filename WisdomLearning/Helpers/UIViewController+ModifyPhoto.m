//
//  UIViewController+ModifyPhoto.m
//  WisdomLearning
//
//  Created by Shane on 16/12/16.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "UIViewController+ModifyPhoto.h"
#import "LGAlertView.h"
#import <objc/runtime.h>

static void *choosePhotoSucessKey = &choosePhotoSucessKey;



@implementation UIViewController (ModifyPhoto)

-(void)toChoosePhotoSucessBlock:(void (^)(UIImage *imageChoose))sucessBlock{
    self.choosePhotoSucessBlock = sucessBlock;
    LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                          style:LGAlertViewStyleActionSheet
                                                   buttonTitles:@[ @"从相册中选择" ]
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"拍照"
                                                  actionHandler:^(LGAlertView* alertView, NSString* title, NSUInteger index) {
                                                      NSLog(@"从相册中选择");
                                                      [self toTakePickByTheWay:1];
                                                  }
                                                  cancelHandler:nil
                                             destructiveHandler:^(LGAlertView* alertView) {
                                                 NSLog(@"拍照");
                                                    [self toTakePickByTheWay:0];
                                             }];
    
    //    alertView.coverColor = [UIColor colorWithWhite:0.85f alpha:0.9];
    alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
    alertView.layerShadowRadius = 4.f;
    alertView.layerCornerRadius = 0.f;
    alertView.layerBorderWidth = 2.f;
    alertView.layerBorderColor = [UIColor whiteColor];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.buttonsHeight = 44.f;
    alertView.buttonsFont = [UIFont systemFontOfSize:15.f];
    alertView.cancelButtonFont = [UIFont systemFontOfSize:15.f];
    alertView.destructiveButtonFont = [UIFont systemFontOfSize:15.f];
    alertView.buttonsTitleColor = [UIColor blackColor];
    alertView.destructiveButtonTitleColor = [UIColor blackColor];
    alertView.cancelButtonTitleColor = [UIColor blackColor];
    alertView.width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    alertView.offsetVertical = 4.f;
    alertView.cancelButtonOffsetY = 0.f;
    alertView.buttonsBackgroundColorHighlighted = [UIColor lightGrayColor];
    alertView.cancelButtonBackgroundColorHighlighted = [UIColor lightGrayColor];
    alertView.destructiveButtonBackgroundColorHighlighted = [UIColor lightGrayColor];
    [alertView showAnimated:YES completionHandler:nil];
    
}

-(void)toTakePickByTheWay:(NSInteger)theWay{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    if (theWay == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不支持拍照功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        // 照相机
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // 4.设置代理
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    ipc.allowsImageEditing=YES;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.choosePhotoSucessBlock) {
            self.choosePhotoSucessBlock(info[UIImagePickerControllerEditedImage]);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  --- setter && getter
-(ChoosePhotoSucessBlock)choosePhotoSucessBlock{
    return  objc_getAssociatedObject(self, &choosePhotoSucessKey);
}

-(void)setChoosePhotoSucessBlock:(ChoosePhotoSucessBlock)choosePhotoSucessBlock{
    objc_setAssociatedObject(self, &choosePhotoSucessKey, choosePhotoSucessBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
