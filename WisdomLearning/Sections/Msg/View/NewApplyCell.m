//
//  NewBuddyCell.m
//  BigMovie
//
//  Created by Shane on 16/4/11.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "NewApplyCell.h"
#import "UIHelper.h"

static NSString *strAgree = @"同意";
static NSString *strRefuse = @"拒绝";

static CGFloat originRatioFroView1 = 0.4;
static CGFloat enlargeRatioForView1 = 0.58;


@implementation NewApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ivAvatar.layer.cornerRadius = 75*0.7/2;
    self.ivAvatar.clipsToBounds = YES;
    [self layoutView];
}

-(void)setModel:(ZSMessageNewFriendModel *)model
{
    _model = model;
    [self layoutView];

}

-(UIView *)view1{
    if (!_view1) {
        _view1 = [UIView new];
    }
    return _view1;
}

-(UIView *)view2{
    if (!_view2) {
        _view2 = [UIView new];
    }
    return _view2;
}

-(UIImageView *)ivAvatar{
    if (!_ivAvatar) {
        _ivAvatar = [UIImageView new];
    }
    return _ivAvatar;
}

-(UILabel *)lbNick{
    if (!_lbNick) {
        _lbNick = [UILabel new];
    }
    return  _lbNick;
}

-(UILabel *)lbIntro{
    if (!_lbIntro) {
        _lbIntro = [UILabel new];
    }
    return  _lbIntro;
}

-(void)layoutView{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.ivAvatar];
    [self.ivAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(self.contentView.mas_height).multipliedBy(0.7);
    }];
    
     [self.ivAvatar sd_setImageWithURL:[_model.USER_PIC stringToUrl]  placeholderImage:KPlaceHeaderImage];
    CGFloat widthRatio = ((_model.APL_STATUS == 0) ? originRatioFroView1 : enlargeRatioForView1);
    
    //CGFloat widthRatio = originRatioFroView1;
    [self layoutView1:widthRatio];
    [self layoutView2WithStatus:_model.APL_STATUS];
   // [self layoutView2WithStatus:0];
}

//nickname 和 intro
-(void)layoutView1:(CGFloat)widthRatio{
    [self.view1 removeFromSuperview];
    [self.view1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.view1];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ivAvatar.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.6);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(widthRatio);
    }];
    
    [self.view1 addSubview:self.lbNick];
    [self.lbNick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view1);
        make.height.equalTo(_view1.mas_height).multipliedBy(0.45);
    }];
    self.lbNick.text = _model.USER_SHORTNAME;
    //self.lbNick.text = @"xu";
    self.lbNick.font = [UIFont systemFontOfSize:14.0f];
    self.lbNick.textColor = KMainBlack;

    
    self.lbIntro = [UILabel new];
//    self.lbIntro.backgroundColor = [UIColor redColor];
    [self.view1 addSubview:self.lbIntro];
    [self.lbIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view1);
        make.height.equalTo(_view1.mas_height).multipliedBy(0.45);
    }];
    self.lbIntro.text = _model.APL_CONTENT;
    //self.lbIntro.text = @"消息";
    self.lbIntro.font = [UIFont systemFontOfSize:14.0f];
    self.lbIntro.textColor = KMainBlack;

}

-(void)layoutView2WithStatus:(NSUInteger)status{
    [self.view2 removeFromSuperview];
    [self.view2.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.view2];
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view1.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.45);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    
    if (status == 0) {
        [self addAndBtnsInView:_view2];
    }else if(status == 1){
        [self addAlreadyBtns:@"已同意" InView:_view2];
    }else{
        [self addAlreadyBtns:@"已拒绝" InView:_view2];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark  --add long press
-(void)addLongPress{
    UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
    [self addGestureRecognizer:headerLongPress];
    
}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_longPressDelegate && _indexPath && [_longPressDelegate respondsToSelector:@selector(longPressAtIndexPath:)])
        {
            [_longPressDelegate longPressAtIndexPath:self.indexPath];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithModel:(id)model{
    return NewBuddyCellMinHeight;
}

+(NSString *)cellIdentifierWithModel:(id)model{
    return NewBuddyCellIdentifier;
}


#pragma mark - add agree and refuse button
//“同意”和“拒绝”按钮
-(void)addAndBtnsInView:(UIView *)view{
    _btnAgree = [[ZSButton alloc] initFlatButtonWithFrame:CGRectMake(0, 0, 0, 0) andTitle:strAgree andTapBlock:^(ZSButton *btn){
        [self.delegate clickAddBtnWithIndex:self.indexPath completionBlock:^{
            [self layoutView1:enlargeRatioForView1];
            [self layoutView2WithStatus:1];
        }];
        
    }];
    [view addSubview:_btnAgree];
    _btnAgree.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(view).with.offset(0);
        make.width.equalTo(view).multipliedBy(0.45);
    }];

    _btnReject = [[ZSButton alloc] initBorderButtonWithFrame:CGRectMake(0, 0, 0, 0) andTitle:strRefuse andTapBlock:^(ZSButton *btn){
        [self.delegate clickRejectBtnWithIndex:self.indexPath completionBlock:^{
            [self layoutView1:enlargeRatioForView1];
            [self layoutView2WithStatus:2];
        }];
        
    }];
    [view addSubview:_btnReject];
    _btnReject.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnReject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(view).with.offset(0);
        make.width.equalTo(view).multipliedBy(0.45);
    }];
}

//“已同意”或“已拒绝”label
-(void)addAlreadyBtns:(NSString *)title InView:(UIView *)view{
    _lbAlready = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:_lbAlready];
    _lbAlready.text = title;
    _lbAlready.font = [UIFont systemFontOfSize:14];
    _lbAlready.textColor = KMainBlack;
    [_lbAlready  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(view);
    }];
}


@end
