//
//  GetHeight.m
//  ElevatorUncle
//
//  Created by DiorSama on 16/6/24.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "GetHeight.h"

@implementation GetHeight

//获取带有行间距地label的高度
+(CGFloat)setText:(NSString *)text LineSpacing:(CGFloat)lineSpacing WithWidth:(CGFloat)width{
    //计算出真实大小
    CGFloat oneRowHeight = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].height;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;


    CGFloat rows = textSize.height / oneRowHeight;
    CGFloat realHeight = oneRowHeight;
    if (rows > 1) {
        realHeight = (rows * oneRowHeight) + (rows - 1) * lineSpacing;
    }

   
    return realHeight;
}

//获取历史记录图片高度
+ (CGFloat)getImagesGirdViewHeight:(NSArray*)imgs withWidth:(CGFloat)width isComplete:(BOOL)isComplete
{
    
    NSInteger picsCount = [imgs count];
    if(picsCount == 0){
        return 0;
    }
    else{
        if(isComplete){
            if(kDevice_Is_iPhone6Plus){
                width= 66*5;
                if(picsCount %5 ==0){
                    return (picsCount / 5) * width / 5 + (picsCount / 5) * 10;
                    
                }
                else{
                    
                    return (picsCount / 5 + 1) * width / 5 + (picsCount / 5+1) * 10;
                }
            }
            else{
                width= 66*4;
                if(picsCount %4 ==0){
                    return (picsCount / 4) * width / 4 + (picsCount / 4) * 10;
                    
                }
                else{
                    
                    return (picsCount / 4 + 1) * width / 4 + (picsCount / 4+1) * 10;
                }
            }

        }
        else{
        if(kDevice_Is_iPhone6Plus){
            width= 66*4;
            if(picsCount %4 ==0){
                return (picsCount / 4) * width / 4 + (picsCount / 4) * 10;
            
            }
            else{
           
                return (picsCount / 4 + 1) * width / 4 + (picsCount / 4+1) * 10;
            }
        }
        else{
            width= 66*3;
            if(picsCount %3 ==0){
                return (picsCount / 3) * width / 3 + (picsCount / 3) * 10;
                
            }
            else{
                
                return (picsCount / 3 + 1) * width / 3 + (picsCount / 3+1) * 10;
            }
        }
        }
        
    }
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(999, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
}

+(CGFloat)hightForText:(NSString *)text andWidth:(CGFloat)width LineSpacing:(CGFloat)lineSpacing{
    //计算出真实大小
    CGFloat oneRowHeight = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].height;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width - 33 - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] } context:nil].size;
    CGFloat rows = size.height / oneRowHeight;
    CGFloat realHeight = oneRowHeight;
    if (rows > 1) {
        realHeight = (rows * oneRowHeight) + (rows - 1) * lineSpacing;
    }
    return realHeight + 45;
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}

//获取年月日
+ (NSString*)getTime:(NSString*)str
{
    NSString * timeStr = nil;
    NSArray * arr = [str componentsSeparatedByString:@" "];
    timeStr = arr[0];
    return timeStr;
}

//获取实际的图片数组
+(NSArray*)getAllArr:(NSString*)imageStr videoStr:(NSString*)video voiceStr:(NSString*)voice
{
    NSArray * hisImageArr = nil;
     NSMutableArray * hisAllArr = [[NSMutableArray alloc]init];
    if(imageStr.length !=0){
        hisImageArr = [imageStr componentsSeparatedByString:@","];
        [hisAllArr addObjectsFromArray:hisImageArr];
    }

    if(video.length>0){
        [hisAllArr addObject:video];
    }
    
    if(voice.length>0){
        [hisAllArr addObject:voice];
    }
    return hisAllArr;
}
@end
