//
//  ZSIntelligentSegment.m
//  WisdomLearning
//
//  Created by Shane on 17/1/12.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "ZSIntelligentSegment.h"
#import "ZSImageTextButton.h"

const CGFloat imageWidth = 12;
const CGFloat imageHeight = 8;
const CGFloat gapImageText = 5;
//const CGFloat xPos = 10;

@interface ZSIntelligentSegment()

@property (nonatomic, strong) UIScrollView *theScrollView;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSArray *selectedImages;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGFloat gapItem;
@property (nonatomic, strong) NSMutableArray *sizeArray;
@property (nonatomic, strong) NSMutableArray *selIndexArray;
@property (nonatomic, assign) CGFloat xPos;
@end

@implementation ZSIntelligentSegment


-(instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andImages:(NSArray *)images andSelectedImages:(NSArray *)selectedImages andTitleFont:(UIFont *)titleFont{
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        _images = images;
        _selectedImages = selectedImages;
        _titleFont = titleFont;
        _sizeArray = @[].mutableCopy;
        _selIndexArray = @[].mutableCopy;
        _selectedIndex = -1;
        
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        
        _theScrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self addSubview:self.theScrollView];
        if(titles.count == 2){
            _xPos =SCREEN_WIDTH/4;
        }
        else{
            _xPos = 10.0;
        }
    }
    return self;
}

-(void)changeTitles:(NSArray *)titles{
    _titles = titles;
    [self setNeedsDisplay];
}

-(void)changeSelectedImages:(NSArray *)selectedImages{
    _selectedImages = selectedImages;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    _gapItem = 20;
    [_theScrollView removeAllSubviews];
   
    CGFloat contentWidth = [self calculateContentWidth];
    _theScrollView.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(self.frame));
    CGFloat x = _xPos;
    for (NSInteger index = 0; index < _titles.count; ++index) {
        NSString *title = _titles[index];
        UIImage *image = _images[index];
        if (index == _selectedIndex) {
            image = _selectedImages[index];
        }
        
        CGRect nowFrame = CGRectMake(x, 0, [_sizeArray[index] floatValue], CGRectGetHeight(self.frame));
        ZSImageTextButton *button = [[ZSImageTextButton alloc] initWithFrame:nowFrame andImageLeft:NO andImage:image andTitle:title andTitleFont:_titleFont];
        button.imageWidth = imageWidth;
        button.imageHeight = imageHeight;
        
//        if (index == _selectedIndex) {
//            button.titleColor = kMainThemeColor;
//        }
        
        if ([_selIndexArray containsObject:@(index)]){
            button.titleColor = kMainThemeColor;
        }
        
        button.tag = index;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        x += (_gapItem+[_sizeArray[index] floatValue]);
        
        [self.theScrollView addSubview:button];
    }
}

-(CGFloat)calculateContentWidth{
    CGFloat buttonsWidth = 0;
    [_sizeArray removeAllObjects];
    
    for (NSInteger index = 0; index < _titles.count; ++index) {
        NSString *title = _titles[index];
        CGFloat width = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleFont} context:nil].size.width + gapImageText + imageWidth;
        [_sizeArray addObject:[NSNumber numberWithFloat:width]];
        buttonsWidth += width;
    }
    
    CGFloat totalWidth = buttonsWidth + (2*_xPos+_gapItem*_titles.count-1);
    if (totalWidth > CGRectGetWidth(self.frame)) {
        _gapItem = 20.f;
    }else{
        _gapItem = (CGRectGetWidth(self.frame)-buttonsWidth-2*_xPos)/(_titles.count-1);
    }
    return 2*_xPos + buttonsWidth + (_titles.count-1)*_gapItem;
}

-(void)buttonClicked:(UIButton *)sender{
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickTheSegmentIndex:)]) {
        [_theDelegate clickTheSegmentIndex:sender.tag];
    }
}

-(void)reloadData{
    [self setNeedsDisplay];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if ([_selIndexArray containsObject:@(_selectedIndex)] == NO) {
        [_selIndexArray addObject:@(_selectedIndex)];
    }
}


@end
