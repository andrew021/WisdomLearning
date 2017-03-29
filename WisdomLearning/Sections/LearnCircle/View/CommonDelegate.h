//
//  CommonDelegate.h
//  ElevatorUncle
//
//  Created by DiorSama on 16/6/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ComDelegate <NSObject>

-(void)interactData:(id)sender tag:(int)tag data:(id)data;

@end

@interface CommonDelegate : NSObject

@end
