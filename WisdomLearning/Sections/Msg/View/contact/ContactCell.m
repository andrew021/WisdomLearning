//
//  ContactCell.m
//  BigMovie
//
//  Created by Shane on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.lbNickName.font = [UIFont fontWithName:@"STKaiti" size:14];
//    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    NSLog(@"[familyNames count]===%d",[familyNames count]);
//    for(indFamily=0;indFamily<[familyNames count];++indFamily)
//        
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
//        
//        for(indFont=0; indFont<[fontNames count]; ++indFont)
//            
//        {
//            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
//            
//        }
//        
////        [fontNames release];
//    }
////    
////    [familyNames release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ZSMessageFriendListModel *)model{
    _model = model;
    self.lbNickName.text = ([_model.USER_SHORTNAME length] > 0) ?
                                        _model.USER_SHORTNAME: model.USER_ID;
    //stringValue
    self.lbIntro.text = model.USER_SIGN;
     [self.ivAvatar sd_setImageWithURL:[_model.USER_PIC stringToUrl]  placeholderImage:KPlaceHeaderImage];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.ivAvatar.layer.cornerRadius = ViewHeight(self.ivAvatar)/2;
    self.ivAvatar.clipsToBounds = YES;
}

+ (CGFloat)cellHeightWithModel:(id)model{
    return ContactCellMinHeight;
}

+(NSString *)cellIdentifierWithModel:(id)model{
    return ContactCellIdentifier;
}

@end
