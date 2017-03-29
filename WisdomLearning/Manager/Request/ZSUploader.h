//
//  ZSUploader.h
//  BigMovie
//
//  Created by Shane on 16/5/5.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSUploaderRespModel : NSObject

@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *url;

@end


@interface ZSUploader : NSObject

+ (ZSUploader*)sharedInstance;

/**
 *  上传图片
 *
 *  @param image 图片data
 *  @param token
 *  @param userid 
 *  @param block 回调 上传成功返回的url
    @param 例子：
         [[ZSUploader sharedInstance] uploadImage:UIImageJPEGRepresentation([UIImage imageNamed:@"avatar"], 0.8)
                 token:@"123"
                 userid:@"123"
                 completeHandler:^(ZSUploaderRespModel *respModel) {
                 if (respModel.url){成功，使用respModel.url}
                 else {失败，提示respModel.msg}
         }];
 *
 */
- (NSURLSessionUploadTask*)uploadImage:(NSData *)image
                                 token:(NSString *)token
                                 userid:(NSString *)userid
                       completeHandler:(void (^)(ZSUploaderRespModel *respModel))block;

- (NSURLSessionUploadTask*)uploadImage:(NSData *)image
                                   url:(NSString *)url
                                 token:(NSString *)token
                                userid:(NSString *)userid
                       completeHandler:(void (^)(ZSUploaderRespModel *respModel))block;

@end
