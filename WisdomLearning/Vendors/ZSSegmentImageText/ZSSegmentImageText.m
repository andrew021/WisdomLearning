//
//  ZSSegmentImageText.m
//  WisdomLearning
//
//  Created by Shane on 16/11/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSSegmentImageText.h"
#import "HMSegmentedControl.h"

@interface ZSSegmentImageText()
{
//    HMSegmentedControl *segment;
}

@end

@implementation ZSSegmentImageText

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)imageNames andImageWidth:(CGFloat)imageWidth andImgHeight:(CGFloat)imageHeight andTitles:(NSArray *)titles andTitleSize:(CGFloat)titleSize{
    if (self = [super initWithFrame:frame]) {
        
        NSMutableArray *images = @[].mutableCopy;
        for (NSString *imgSrc in imageNames) {
            UIImage *image = [UIImage imageNamed:imgSrc];
            UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
            
            [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [images addObject:scaledImage];
        }

        
        HMSegmentedControl * segment = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:images titlesForSections:titles];
        
        segment.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        segment.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segment.verticalDividerEnabled = NO;
        segment.selectionIndicatorHeight = 0.0f;
        segment.selectionIndicatorColor = kMainThemeColor;
        segment.type = HMSegmentedControlTypeTextImages;
        segment.selectedSegmentIndex = HMSegmentedControlNoSegment;
        [segment setTitleFormatter:^NSAttributedString*(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        UIFont *font = [UIFont systemFontOfSize:titleSize];
            
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? [UIColor darkGrayColor] : [UIColor darkGrayColor],NSFontAttributeName : font }];
            return attString;
        }];
        [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:segment];
    }
    return self;
}

-(void)segmentValueChange:(HMSegmentedControl *)segmentedControl{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickImageText:)]) {
        [_theDelegate clickImageText:index];
        segmentedControl.selectedSegmentIndex = HMSegmentedControlNoSegment;
    }
}

//-(HMSegmentedControl *)segmentWithFrame:(CGRect)frame andImages:(NSArray *)imageNames andTitles:(NSArray *)titles{
//    NSMutableArray *images = @[].mutableCopy;
//    for (NSString *imgSrc in imageNames) {
//        UIImage *image = [UIImage imageNamed:imgSrc];
//        CGFloat height = 50, width = 50;
//        UIGraphicsBeginImageContext(CGSizeMake(width, height));
//        
//        [image drawInRect:CGRectMake(0, 0, width, height)];
//        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        [images addObject:scaledImage];
//    }
//    
//    segment = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:images titlesForSections:titles];
//    
//    segment.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
//    segment.frame = frame;
//    segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
//    segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    segment.verticalDividerEnabled = NO;
//    segment.selectionIndicatorHeight = 0.0f;
//    segment.selectionIndicatorColor = KMainBlue;
//    segment.type = HMSegmentedControlTypeTextImages;
//    segment.selectedSegmentIndex = HMSegmentedControlNoSegment;
//    [segment setTitleFormatter:^NSAttributedString*(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
//        
//        UIFont *font = [UIFont systemFontOfSize:14];
//        
//        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? KMainBlue : [UIColor darkGrayColor],NSFontAttributeName : font }];
//        return attString;
//    }];
//    [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
//    
//    return segment;
//}

@end
