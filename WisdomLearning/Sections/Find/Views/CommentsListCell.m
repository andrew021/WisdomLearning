//
//  CommentsListCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/14.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CommentsListCell.h"

static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@".+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return _nameRegularExpression;
}

static inline NSRegularExpression * ParenthesisRegularExpression() {
    static NSRegularExpression *_parenthesisRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\([^\\(\\)]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _parenthesisRegularExpression;
}


@implementation CommentsListCell

//@synthesize summaryLabel = _summaryLabel;
//@synthesize summaryText = _summaryText;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
//        self.layer.shouldRasterize = YES;
//        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.summaryLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.summaryLabel.font = [UIFont systemFontOfSize:16.0f];
        self.summaryLabel.textColor = [UIColor blackColor];
        self.summaryLabel.backgroundColor=[UIColor clearColor];
        NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
        [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.linkAttributes=@{(__bridge NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleNone],(__bridge NSString *)kCTForegroundColorAttributeName:[UIColor colorFromHexString:@"576d92"]};
        
        [self.summaryLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:self.summaryLabel];
    }
    return self;
}

-(void)setReplyModel:(ZSReplyInfo *)replyModel{
    _replyModel = replyModel;
        [self.summaryLabel setText:self.summaryText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
            NSRegularExpression *regexp = NameRegularExpression();
            NSRange nameRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];
            UIFont *boldSystemFont = [UIFont systemFontOfSize:16.0f];
    
            CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (boldFont) {
                [mutableAttributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:nameRange];
                [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:nameRange];
                CFRelease(boldFont);
            }
    
            regexp = ParenthesisRegularExpression();
            [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, __unused NSMatchingFlags flags, __unused BOOL *stop) {
                UIFont *italicSystemFont = [UIFont italicSystemFontOfSize:16.0f];
                CTFontRef italicFont = CTFontCreateWithName((__bridge CFStringRef)italicSystemFont.fontName, italicSystemFont.pointSize, NULL);
                if (italicFont) {
                    [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicFont range:result.range];
                    CFRelease(italicFont);
    
                    [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[[UIColor grayColor] CGColor] range:result.range];
                }
            }];
    
            return mutableAttributedString;
        }];
    
        //设置点击部分
        NSRegularExpression *regexp = NameRegularExpression();
        NSRange linkRange = [regexp rangeOfFirstMatchInString:_summaryText options:0 range:NSMakeRange(0, [_replyModel.replyerName length])];
    
        NSString *str=[NSString stringWithFormat:@"%@", [_summaryText substringWithRange:linkRange]];
        NSString *sss = [NSString stringWithFormat:@"%@_%@", str, _replyModel.replyerId];
        NSURL *url = [NSURL URLWithString:[sss stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.summaryLabel addLinkToURL:url withRange:linkRange];
    
        NSRange linkRange1 = [regexp rangeOfFirstMatchInString:_summaryText options:0 range:NSMakeRange(2+[_replyModel.replyerName length], [_replyModel.userName length])];
        NSString *str1=[NSString stringWithFormat:@"%@", [_summaryText substringWithRange:linkRange1]];
    
        // add 2016-5-13
        sss = [NSString stringWithFormat:@"%@_%@", str1, _replyModel.userId];
        NSURL *url1 = [NSURL URLWithString:[sss stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.summaryLabel addLinkToURL:url1 withRange:linkRange1];
    
    [self.summaryLabel setNeedsDisplay];
}


#pragma mark - UIView
//
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    
    CGRect rect=CGRectMake(self.bounds.origin.x+70, self.bounds.origin.y, self.bounds.size.width-70, self.bounds.size.height);
//    self.summaryLabel.frame = CGRectOffset(CGRectInset(rect, 70.0f, 0.0f), -10.0f, 0.0f);
    self.summaryLabel.frame = rect;
  
    
    [self setNeedsDisplay];
}




@end
