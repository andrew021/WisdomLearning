//
//  ITTSegement.m
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import "ITTSegement.h"

@implementation ITTSegement
{
    NSMutableArray *allItems;
    CGFloat itemGap;
    NSMutableArray *itemsWidthArr;
    
}

-(id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        [self _initViews:items];
    }
    return self;
}


-(void)calculateItemGap{
    CGFloat textTotalLength = 0;
    for (int i = 0; i < self.items.count; ++i) {
        NSString *itemName = self.items[i];
        CGSize size = [itemName boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        textTotalLength += (size.width+16+20);
    }
    itemGap = ([UIScreen mainScreen].bounds.size.width-textTotalLength)/(self.items.count-1);
}

-(void)_initViews:(NSArray *)items
{
    self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    allItems = [[NSMutableArray alloc] initWithCapacity:items.count];
    itemsWidthArr = [[NSMutableArray alloc] initWithCapacity:items.count];
    [itemsWidthArr addObject:@(0)];
    self.items = items;
    
    float x = 0;
    [self calculateItemGap];
    
    for (int i = 0; i < items.count; i++) {
        NSString *itemName = items[i];
        
        CGSize size = [itemName boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        
        float itemWidth = size.width + 16 + 20;
        

        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, itemWidth, 35)];
        
        UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(5, 0, size.width,35)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = itemName;
        titleLabel.tag = 2013;
        [itemView addSubview:titleLabel];
        
        CGFloat xGap = 22;
        if (kDevice_Is_iPhone4 || kDevice_Is_iPhone5) {
            xGap = 22;
        }
        ITTArrowView *arrowView = [[ITTArrowView alloc] initWithFrame:CGRectMake(itemWidth-xGap, 14, 10, 8)];
//        arrowView.backgroundColor = [UIColor redColor];
        
        __weak ITTSegement *this = self;
        arrowView.block = ^(ArrowStates state){
            ITTSegement *strong = this;
            strong.currentState = state;
        };
        
        arrowView.tag = 2014;
        if (i == 0) {
            arrowView.isSelected = YES;
        }
        [itemView addSubview:arrowView];
        
        
        [self addSubview:itemView];
        [allItems addObject:itemView];
        
        x += (itemWidth+itemGap);
        
        [itemsWidthArr addObject:@(x)];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorFromHexString:@"d8d8d8"];
    [self addSubview:line];
}

-(void)setSelectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
//    float itemWidth = [UIScreen mainScreen].bounds.size.width/_items.count;
    
    for (int i = 0; i < allItems.count; i++) {
        UIView *itemView = allItems[i];
        UILabel *titleLabel = (UILabel *)[itemView viewWithTag:2013];
        ITTArrowView *arrowView = (ITTArrowView *)[itemView viewWithTag:2014];
//        UIImageView *indexView = (UIImageView *)[itemView viewWithTag:2015];
        if (i == selectedIndex) {
            
//            titleLabel.textColor = [UIColor redColor];
            titleLabel.textColor = kMainThemeColor;
            arrowView.isSelected = YES;
//            indexView.frame = CGRectMake(0, 37, itemWidth, 3);
//            indexView.image = [UIImage imageNamed:@"index_press.png"];
        } else {
            titleLabel.textColor = [UIColor blackColor];
            arrowView.isSelected = NO;
//            indexView.image = [UIImage imageNamed:@"index.png"];
//            indexView.frame = CGRectMake(0, 39, itemWidth, 1);
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
//    float width = [UIScreen mainScreen].bounds.size.width/self.items.count;
//    int index = point.x /width;
//    self.selectedIndex = index;
    
    for (int i = 0; i < self.items.count; i++){
        float x = [itemsWidthArr[i] floatValue];
        float xNext = [itemsWidthArr[i+1] floatValue];
        if (point.x > x && point.x < xNext) {
            self.selectedIndex = i;
            break;
        }
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}



@end

