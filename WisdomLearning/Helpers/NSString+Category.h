//
//  NSString+Category.h
//  WisdomLearning
//
//  Created by Shane on 16/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)


-(NSString *)add:(NSString *)theString;

-(NSMutableAttributedString *)takeString:(NSString *)sss toColor:(UIColor *)color isBefore:(BOOL)isBefore;

-(NSURL *)stringToUrl;

-(NSString*)stringToUserPic;

@end
