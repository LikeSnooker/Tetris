//
//  PSPScreen.h
//  PSP
//
//  Created by 张雨 on 15/5/29.
//  Copyright (c) 2015年 张雨. All rights reserved.
//

#import <UIKit/UIKit.h>
struct ScreenData
{
    bool matrix[20][10];
};
struct NextScreenData
{
    bool matrix[2][4];
};
@protocol PSPScreenDataSource <NSObject>
@optional
-(BOOL)showLine;//为将来预留接口  不是所有游戏都会显示Line
-(BOOL)showNext;//同上
@required
-(unsigned int)highScore;
-(unsigned int)score;
-(unsigned int)line;
-(unsigned int)level;
-(struct ScreenData    )dataForShow;
-(struct NextScreenData)nextForShow;
@end
@interface PSPScreen : UIView
{
#define SCR_LIGHTEN_CLR   [UIColor colorWithRed:41/255.0  green:48/255.0 blue:41/255.0 alpha:1.0]
#define SCR_UNLIGHTEN_CLR [UIColor colorWithRed:141/255.0 green:176/255.0 blue:140/255.0 alpha:1.0]
#define SCR_BG_CLR        [UIColor colorWithRed:150/255.0 green:183/255.0 blue:149/255.0 alpha:1.0]
    const bool **_matrix;
}
@property (nonatomic) id<PSPScreenDataSource> dataSource;
+(id)  sharedScreen;
@end
