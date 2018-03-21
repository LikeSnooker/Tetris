//
//  PSPGame.h
//  PSP
//
//  Created by 张雨 on 15/5/29.
//  Copyright (c) 2015年 张雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPScreen.h"
@interface PSPGame : NSObject
{

}
+(id)sharedInstance;
-(void)upKey;
-(void)downKey;
-(void)leftKey;
-(void)rightKey;
-(void)reset;
-(void)start;
-(void)pause_resume;
-(void)mainKeyFun;
-(void)saveState;
-(void)reseverState;
@end
