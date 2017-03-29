//
//  NewGroupCell.m
//  BigMovie
//
//  Created by Shane on 16/4/12.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "NewGroupCell.h"

@implementation NewGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithModel:(id)model{
    return NewGroupCellMinHeight;
}

+(NSString *)cellIdentifierWithModel:(id)model{
    return NewGroupCellIdentifier;
}

-(void)setGroup:(ZSMessageGroupModel *)group{
    if (group != nil) {
        if (group.GP_NAME && group.GP_NAME.length > 0) {
            self.lbGroupSubject.text =group.GP_NAME;
        }
        else {
            self.lbGroupSubject.text = group.GP_ID;
        }
    }
    self.ivAvatar.image = [ThemeInsteadTool imageWithImageName:@"group_icon"];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.ivAvatar.layer.cornerRadius = ViewHeight(self.ivAvatar)/2;
    self.ivAvatar.clipsToBounds = YES;
}


@end
