//
//  PSPGameTetris.h
//  PSP
//
//  Created by 张雨 on 15/5/29.
//  Copyright (c) 2015年 张雨. All rights reserved.
//

#import "PSPGame.h"
#import "PSPScreen.h"
@interface PSPGameTetris : PSPGame<PSPScreenDataSource>
{
    enum GameState
    {
        STARTED = 0,
        PAUSE   = 1,
        STOP    = 2
    };
    NSTimer     * _timer;
    bool          _smallBox[4][4];
    bool          _bigBox[20][10];
    int           _smallBox_line;
    int           _smallBox_row;
    enum GameState     _gameState;
    int                _currentStyle; //当前类型
    int                _nextStyle;    //下一个方块的类型    
#define WIDTH  10
#define HEIGHT 20
#define BE_IN_BOX(row,line)      _smallBox_line+line < 10 && _smallBox_line+ line > -1 && _smallBox_row+row > -1 && _smallBox_row+row < 20   //判断smallBox中的一个cell在bixBox中是否越界
#define REFRESH_SCREEN [[NSNotificationCenter defaultCenter] postNotificationName:@"NEEDSDISPLAY" object:nil]
    unsigned int _high_score;
    unsigned int _score;
    unsigned int _line;
    unsigned int _level;
    bool         _inAnimation;
    struct ScreenData _data;
}
@property (nonatomic,assign)  BOOL           crazyMode;
@property (nonatomic,readonly)enum GameState gameState;
-(void)generalData;
-(void)reset;
-(void)start;
-(void)pause_resume;
-(void)mainKeyFun;
-(void)saveState;
-(void)reseverState;
-(void)fastDown;
@end
