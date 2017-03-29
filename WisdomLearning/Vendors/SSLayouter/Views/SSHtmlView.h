//
//  SSHtmlView.h
//  DTCoreText
//
//  Created by su on 16/5/25.
//  Copyright © 2016年 Drobnik.com. All rights reserved.
//

#import "SSAttributedTextView.h"
#import "SSLayouterConfig.h"
#import "SSImageObject.h"
#import <CoreText/CoreText.h>

@class SSHtmlView;

@protocol SSHtmlViewDelegate <NSObject>

@optional
/**
 *  点击图片的时候调用
 *
 *  @param htmlView    网页排版视图
 *  @param imageObject 图片对象
 */
- (void) htmlView:(SSHtmlView *)htmlView clickImage:(SSImageObject *)imageObject;

/**
 *  点击链接（<a href="test">a标签</a>）的时候调用
 *
 *  @param htmlView 网页排版视图
 *  @param url a标签里面的href的值
 */
- (void) htmlView:(SSHtmlView *)htmlView clickUrl:(NSURL *)url;

@end


@interface SSHtmlView : SSAttributedTextView

/**
 *  排版的HTML
 */
@property(nonatomic, copy) NSString *html;
/**
 *  当前排版里面所有的图像文件
 */
@property(nonatomic, strong) NSMutableArray *imageObjects;

/**
 *  代理 ---> 点击图片时：- (void) htmlView:(SSHtmlView *)htmlView clickImage:(SSImageObject *)imageObject;
 *       ---> 点击链接时：- (void) htmlView:(SSHtmlView *)htmlView clickUrl:(NSURL *)url;
 */
@property(nonatomic, weak) id<SSHtmlViewDelegate> htmlViewDelegate;

/**
 *  暂停所有的视频播放器、一般在应用程序进入后台，或者当前视频不在可视范围内时调用
 *  举例：在viewcontroller中的viewWillDisappear方法里调用
 */
- (void) pauseAllVideoPlayer;

@end
