//
//  ZSUploader.m
//  BigMovie
//
//  Created by Shane on 16/5/5.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "ZSUploader.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSObject+YYModel.h"
#import "NSString+YYAdd.h"

#define kBoundary      @"----WebKitFormBoundaryVnD2S3sOElp1cDdI"
#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]
#define kZSUploadTimeOut (60)

extern NSString *imguploadurl ;

@implementation ZSUploaderRespModel

- (NSString *)url {
    
    if (_filename) {
            return [NSString stringWithFormat:@"%@%@", kZSResourceUrl,_filename];
    }
    return nil;
}

@end

@interface ZSUploader ()

@property (nonatomic, strong) AFHTTPSessionManager* manager;

@end

@implementation ZSUploader

+ (ZSUploader *)sharedInstance {
    
    static ZSUploader* sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = kZSUploadTimeOut;
        
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];

    }
    
    return self;
}

-(NSURLSessionUploadTask *)uploadImage:(NSData *)imageData url:(NSString *)url token:(NSString *)token userid:(NSString *)userid completeHandler:(void (^)(ZSUploaderRespModel *))block{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@?token=%@&userid=%@", url, token, userid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uploadUrl]];
    request.HTTPMethod = @"POST";
    NSString *header = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    NSString *userAgent = [self getUserAgent];
    
    [request setValue:header forHTTPHeaderField:@"Content-Type"];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSData *postData = [self configBodyWithImageData:imageData];
    NSURLSessionUploadTask *uploadTask = [_manager uploadTaskWithRequest:request fromData:postData progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", responseObject);
        if (!error) {
            ZSUploaderRespModel *respModel = [ZSUploaderRespModel modelWithDictionary:responseObject];
            block(respModel);
        }
        else {
            block(nil);
        }
    }];
    
    [uploadTask resume];
    
    return uploadTask;

}

- (NSURLSessionUploadTask*)uploadImage:(NSData *)imageData
                                 token:(NSString *)token
                                userid:(NSString *)userid
                       completeHandler:(void (^)(ZSUploaderRespModel *respModel))block {
//    if (!imageData || imageData.length == 0) {
//        if (block)  block(nil, @"上传图片不能为空");
//        return nil;
//    }
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@?token=%@&userid=%@", imguploadurl, token, userid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uploadUrl]];
    request.HTTPMethod = @"POST";
    NSString *header = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    NSString *userAgent = [self getUserAgent];
    
    [request setValue:header forHTTPHeaderField:@"Content-Type"];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSData *postData = [self configBodyWithImageData:imageData];
    NSURLSessionUploadTask *uploadTask = [_manager uploadTaskWithRequest:request fromData:postData progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", responseObject);
        if (!error) {
            ZSUploaderRespModel *respModel = [ZSUploaderRespModel modelWithDictionary:responseObject];
            block(respModel);
        }
        else {
            block(nil);
        }
    }];
    
    [uploadTask resume];
    
    return uploadTask;
}

- (NSData *)configBodyWithImageData:(NSData*)imageData {
    
    NSMutableData *formData = [NSMutableData data];
    [formData appendData:[[NSString stringWithFormat:@"--%@",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [formData appendData:KNewLine];
    NSString *randomFileName = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    
    NSString *name = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"",randomFileName,randomFileName];
    
    [formData appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    [formData appendData:KNewLine];
    [formData appendData: [@"Content-Type: image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
    [formData appendData:KNewLine];
    [formData appendData:KNewLine];

    [formData appendData:imageData];
    [formData appendData:KNewLine];
    
//    [formData appendData:[[NSString stringWithFormat:@"--%@",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [formData appendData:KNewLine];
//    
//    [formData appendData:[@"Content-Disposition: form-data; name=\"token\"" dataUsingEncoding:NSUTF8StringEncoding]];
//    [formData appendData:KNewLine];
//    [formData appendData:KNewLine];
//    [formData appendData:[token dataUsingEncoding:NSUTF8StringEncoding]];
//    [formData appendData:KNewLine];
//    
//    [formData appendData:[[NSString stringWithFormat:@"--%@",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [formData appendData:KNewLine];
//    
//    [formData appendData:[@"Content-Disposition: form-data; name=\"userid\"" dataUsingEncoding:NSUTF8StringEncoding]];
//    [formData appendData:KNewLine];
//    [formData appendData:KNewLine];
//    [formData appendData:[userid dataUsingEncoding:NSUTF8StringEncoding]];
//    [formData appendData:KNewLine];
    
    [formData appendData:[[NSString stringWithFormat:@"--%@--",kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return formData;
}

-(NSString *)getUserAgent {
    return [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
}

@end
