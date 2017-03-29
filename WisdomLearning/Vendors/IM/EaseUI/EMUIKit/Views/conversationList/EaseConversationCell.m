/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseConversationCell.h"

#import "EMConversation.h"
#import "UIImageView+EMWebCache.h"

CGFloat const EaseConversationCellPadding = 10;

@interface EaseConversationCell()

@property (nonatomic) NSLayoutConstraint *titleWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *titleWithoutAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithoutAvatarLeftConstraint;

@end

@implementation EaseConversationCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseConversationCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor blackColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:17];
    cell.detailLabelColor = [UIColor lightGrayColor];
    cell.detailLabelFont = [UIFont systemFontOfSize:15];
    cell.timeLabelColor = [UIColor blackColor];
    cell.timeLabelFont = [UIFont systemFontOfSize:13];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showAvatar = YES;
        [self _setupSubview];
    }
    [self addLongPress];
    return self;
}

#pragma mark  --add long press
-(void)addLongPress{
    UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
    [self addGestureRecognizer:headerLongPress];
    
}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(longPressAtIndexPath:)])
        {
            [_delegate longPressAtIndexPath:self.indexPath];
        }
    }
}

#pragma mark - private layout subviews

- (void)_setupSubview
{
    _avatarView = [[EaseImageView alloc] init];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatarView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.font = _timeLabelFont;
    _timeLabel.textColor = _timeLabelColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 1;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = _titleLabelFont;
    _titleLabel.textColor = _titleLabelColor;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = _detailLabelFont;
    _detailLabel.textColor = _detailLabelColor;
    [self.contentView addSubview:_detailLabel];
    
    _pointView = [[UIView alloc]init];
    _pointView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_pointView];
    [self _setupPointView];
    [self _setupAvatarViewConstraints];
    [self _setupTimeLabelConstraints];
    [self _setupTitleLabelConstraints];
    [self _setupDetailLabelConstraints];
}

#pragma mark - Setup Constraints

- (void)_setupAvatarViewConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    self.avatarView.layer.cornerRadius = 45/2;
  
    self.avatarView.layer.masksToBounds = YES;
}

-(void)_setupPointView
{
    _pointView.frame = CGRectMake(50, 5, 8, 8);
    _pointView.layer.cornerRadius = 8/2;
    _pointView.layer.masksToBounds = YES;
}

- (void)_setupTimeLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
}

- (void)_setupTitleLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.timeLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseConversationCellPadding]];
    
    self.titleWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding+10];
    self.titleWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
    [self addConstraint:self.titleWithAvatarLeftConstraint];
}

- (void)_setupDetailLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
    
    self.detailWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding+10];
    self.detailWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
    [self addConstraint:self.detailWithAvatarLeftConstraint];
}

#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.avatarView.hidden = !showAvatar;
        if (_showAvatar) {
            [self removeConstraint:self.titleWithoutAvatarLeftConstraint];
            [self removeConstraint:self.detailWithoutAvatarLeftConstraint];
            [self addConstraint:self.titleWithAvatarLeftConstraint];
            [self addConstraint:self.detailWithAvatarLeftConstraint];
        }
        else{
            [self removeConstraint:self.titleWithAvatarLeftConstraint];
            [self removeConstraint:self.detailWithAvatarLeftConstraint];
            [self addConstraint:self.titleWithoutAvatarLeftConstraint];
            [self addConstraint:self.detailWithoutAvatarLeftConstraint];
        }
    }
}

- (void)setModel:(id<IConversationModel>)model
{
    _model = model;
    
    if ([_model.title length] > 0) {
        self.titleLabel.text = _model.title;
    }
    else{
        self.titleLabel.text = _model.conversation.conversationId;
    }
    
    if (self.showAvatar) {
        if ([_model.avatarURLPath length] > 0){
            
           // @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png"
            [self.avatarView.imageView sd_setImageWithURL:[_model.avatarURLPath stringToUrl] placeholderImage:KPlaceHeaderImage];
            
        } else {
            if (_model.avatarImage) {
                self.avatarView.image = _model.avatarImage;
            }
        }
    }
    
    if (_model.conversation.unreadMessagesCount == 0) {
        _avatarView.showBadge = NO;
        _pointView.hidden = YES;
    }
    else{
        _avatarView.showBadge = NO;
       // _avatarView.showBadge = YES;
       // _avatarView.badge = _model.conversation.unreadMessagesCount;
        _pointView.hidden = NO;
    }
    self.avatarView.imageView.backgroundColor = [UIColor whiteColor];
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}

- (void)setDetailLabelFont:(UIFont *)detailLabelFont
{
    _detailLabelFont = detailLabelFont;
    _detailLabel.font = _detailLabelFont;
}

- (void)setDetailLabelColor:(UIColor *)detailLabelColor
{
    _detailLabelColor = detailLabelColor;
    _detailLabel.textColor = _detailLabelColor;
}

- (void)setTimeLabelFont:(UIFont *)timeLabelFont
{
    _timeLabelFont = timeLabelFont;
    _timeLabel.font = _timeLabelFont;
}

- (void)setTimeLabelColor:(UIColor *)timeLabelColor
{
    _timeLabelColor = timeLabelColor;
    _timeLabel.textColor = _timeLabelColor;
}

#pragma mark - class method

+ (NSString *)cellIdentifierWithModel:(id)model
{
    return @"EaseConversationCell";
}

+ (CGFloat)cellHeightWithModel:(id)model
{
    return EaseConversationCellMinHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (_avatarView.badge) {
        _avatarView.badgeBackgroudColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (_avatarView.badge) {
        _avatarView.badgeBackgroudColor = [UIColor redColor];
    }
}

@end
