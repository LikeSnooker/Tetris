//
//  PSPGame.m
//  PSP
//
//  Created by 张雨 on 15/5/29.
//  Copyright (c) 2015年 张雨. All rights reserved.
//

#import "PSPGame.h"

@implementation PSPGame
static PSPGame * _instance = nil;
-(void)upKey
{

}
-(void)downKey
{

}
-(void)leftKey
{

}
-(void)rightKey
{

}
-(void)reset
{

}
-(void)start
{

}
-(void)pause_resume
{

}
-(void)mainKeyFun
{
}
-(void)saveState
{

}
-(void)reseverState
{

}
+(id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [[self class] sharedInstance];
}
+(id) copyWithZone: (struct _NSZone*)zone
{
    return [[self class] sharedInstance];
}
@end


