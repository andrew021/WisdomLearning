//
//  UIViewController+Request.m
//  ZONRY_Biz
//
//  Created by wayne on 16/4/23.
//  Copyright © 2016年 Razi. All rights reserved.
//

#import "UIViewController+Request.h"
#import <objc/runtime.h>

static const void* kZSRequestKey = &kZSRequestKey;

@implementation UIViewController (Request)

- (ZSRequest*)request
{
    if (objc_getAssociatedObject(self, kZSRequestKey)) {
        return objc_getAssociatedObject(self, kZSRequestKey);
    }
    else {
        ZSRequest* request = [ZSRequest new];
        objc_setAssociatedObject(self, kZSRequestKey, request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return request;
    }
}

- (void)setRequest:(ZSRequest*)request
{
    objc_setAssociatedObject(self, kZSRequestKey, request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end