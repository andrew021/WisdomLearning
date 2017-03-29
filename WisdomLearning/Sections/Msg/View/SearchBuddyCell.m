//
//  SearchBuddyCell.m
//  BigMovie
//
//  Created by Shane on 16/4/15.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "SearchBuddyCell.h"


@implementation SearchBuddyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithModel:(id)model{
    return SearchBuddyCellMinHeight;
}

+(NSString *)cellIdentifierWithModel:(id)model{
    return SearchBuddyCellIdentifier;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.ivAvatar.layer.cornerRadius = ViewHeight(self.ivAvatar)/2;
    self.ivAvatar.clipsToBounds = YES;
}

-(void)setModel:(ZSMessageFriendListModel *)model{
    _model = model;
    
    if(_isGroup){
        self.ivAvatar.image = [ThemeInsteadTool imageWithImageName:@"group_icon"];
         _conversationType = EMConversationTypeGroupChat;
    }
    else{
        [self.ivAvatar sd_setImageWithURL:[model.USER_PIC stringToUrl]  placeholderImage:KPlaceHeaderImage];
        _conversationType = EMConversationTypeChat;
    }
     _conversationId = model.USER_ID;
    _title = model.USER_SHORTNAME;
    self.lbNickName.text = model.USER_SHORTNAME;
    
//    if (_searchText && _searchText.length>0) {
//        NSRange range = [model.USER_SHORTNAME rangeOfString:_searchText options:NSCaseInsensitiveSearch];
//        if (range.location == NSNotFound) {
//            self.lbNickName.text = model.USER_SHORTNAME;
//        }else{
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.USER_SHORTNAME];
//            [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
//            self.lbNickName.attributedText = str;
//        }
//    }
}


@end
