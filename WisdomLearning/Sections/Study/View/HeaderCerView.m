//
//  HeaderCerView.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "HeaderCerView.h"

@implementation HeaderCerView

- (void)awakeFromNib
{
    self.avaterUrl.layer.cornerRadius = 40.0;
    self.avaterUrl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avaterUrl.layer.borderWidth = 3.0;
    
    self.bgImage.image = [ThemeInsteadTool imageWithImageName:@"cer_bg"];
    self.nameImage.image = [ThemeInsteadTool imageWithImageName:@"cer_decorate"];
}

@end
