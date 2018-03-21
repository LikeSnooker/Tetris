//
//  PSPGameTetris.m
//  PSP
//
//  Created by 张雨 on 15/5/29.
//  Copyright (c) 2015年 张雨. All rights reserved.
//

#import "PSPGameTetris.h"

#import "SoundTools.h"
@implementation PSPGameTetris
-(id)init
{
    self=[super init];
    if(self)
    {
        _nextStyle     = (arc4random() % 7);
        [self generalSmallBoxWithStyle:(arc4random() % 7)];
        _smallBox_line = 3;
        _smallBox_row  = -3;
        _gameState     = STOP;
        self.score     = 0;
        _level         = 1;
        _timer=[NSTimer timerWithTimeInterval:0.08 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer setFireDate:[NSDate distantFuture]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(APPWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}
#pragma mark getter and setter
-(void)setCrazyMode:(BOOL)crazyMode
{
    _crazyMode = crazyMode;
    [self generalData];
    REFRESH_SCREEN;
}
#pragma mark timer event_handle
-(void)timerHandle
{
    static unsigned int sum = 0;
    sum ++;
    if(sum >  10 -_level )
    {
        sum =0;
        [self downKey];
    }
}
#pragma mark private function
-(unsigned int)notShowCount //4*4格子阵中还没有被显示出来的格子的数量
{
    unsigned int result  = 0;
    for(int row=0;row<4;row++)
    {
        for(int line=0;line<4;line++)
        {
            if(_smallBox[row][line])
            {
                if(_smallBox_row +row < 0)
                {
                    result ++;
                }
            }
        }
    }
    return result;
}
-(unsigned int)leftOutLineCount
{
    unsigned int result = 0;
    BOOL outLine;
    for(int line=0;line<4;line++)
    {
        outLine = false;
        for(int row =0;row<4;row++)
        {
            if(_smallBox[row][line] && line + _smallBox_line <0 )
            {
                outLine = true;
            }
        }
        if (outLine) {
            result ++;
        }
    }
    return result;
};
-(unsigned int)rightOutLineCount
{
    unsigned int result = 0;
    BOOL outLine;
    for(int line=0;line<4;line++)
    {
        outLine = false;
        for(int row =0;row<4;row++)
        {
            if(_smallBox[row][line] && line + _smallBox_line > 9 )
            {
                outLine = true;
            }
        }
        if (outLine) {
            result ++;
        }
    }
    return result;
}
-(unsigned int)downOutCount
{
    unsigned int result = 0;
    for(int row =0 ;row <4;row++)
    {
        for(int line =0;line<4;line++)
        {
            if(_smallBox[row][line])
            {
                if(row +_smallBox_row >19)
                    result++;
            }
        }
    }
    return result;
}
-(unsigned int)outCount//获得此时超出边界的格子数量
{
    unsigned int result  = 0;
    for(int row=0;row<4;row++)
    {
        for(int line=0;line<4;line++)
        {
            if(_smallBox[row][line])
            {
                if(_smallBox_row +row >19|| _smallBox_line +line < 0 || _smallBox_line + line > 9)
                {
                    result ++;
                }
            }
        }
    }
    return result;
}
-(unsigned int)collisionCount
{
    unsigned int result  = 0;
    for(int row=0;row<4;row++)
    {
        for(int line=0;line<4;line++)
        {
            if(_smallBox[row][line])
            {
                if(BE_IN_BOX(row,line))
                {
                    if(_bigBox[row + _smallBox_row][line + _smallBox_line])
                    {
                        result ++;
                    }
                }
            }
        }
    }
    return result;
}
-(void)fixedSmallBox
{
    [[SoundTools sharedInstance] playDown];
    for(int row=0;row<4;row++)
    {
        for(int line=0;line<4;line++)
        {
            if(BE_IN_BOX(row, line))
            {
                _bigBox[_smallBox_row+row][_smallBox_line+line]|=_smallBox[row][line];
            }
        }
    }
}
-(void)eliminate
{
    int eliminateRowCount=0;
    BOOL have_gap;
    for(int row=HEIGHT-1;row>-1;row--)
    {
        have_gap = false;
        for(int line = 0 ; line < WIDTH ; line++)
        {
            if(_bigBox[row][line]==0)
            {
                have_gap = true;
                break;
            }
        }
        if(!have_gap)
        {
            for(int ss=row;ss>0;ss--)
            {
                for(int ll=0;ll<WIDTH;ll++)
                {
                    _bigBox[ss][ll]=_bigBox[ss-1][ll];
                }
            }
            eliminateRowCount++;
            row++;
        }
    }
    
    switch (eliminateRowCount) {
        case 1:
            [[SoundTools sharedInstance] playDelete1];
            self.score+=100;
            _line ++;
            break;
        case 2:
            [[SoundTools sharedInstance] playDelete2];
            self.score+=200;
            _line +=2;
            break;
        case 3:
            [[SoundTools sharedInstance] playDelete3];
            self.score+=400;
            _line +=3;
            break;
        case 4:
            [[SoundTools sharedInstance] playDelete4];
            self.score+=800;
            _line +=4;
            break;
        default:
            break;
    }
    [self generalData];
    REFRESH_SCREEN;
}
-(void)rotateSmallBox
{
    [[SoundTools sharedInstance] playRotation];
    BOOL oldSmall[4][4];
    memcpy(oldSmall, _smallBox,sizeof(BOOL[4][4]));
    if(_currentStyle==3)
    {
        return;
    }
    else if(_currentStyle==0)
    {
        if(_smallBox[0][1]==0)
        {
            for(int row=0;row<4;row++)
            {
                for(int line=0;line<4;line++)
                {
                    _smallBox[row][line]=(line==1);
                }
            }
        }
        else
        {
            for(int row=0;row<4;row++)
            {
                for(int line=0;line<4;line++)
                {
                    _smallBox[row][line]=(row==2);
                }
            }
        }
    }
    else if(_currentStyle==4)
    {
        if(_smallBox[0][0]==1)
        {
            _smallBox[0][0]=0;
            _smallBox[1][2]=0;
            _smallBox[1][0]=1;
            _smallBox[2][0]=1;
        }
        else
        {
            _smallBox[0][0]=1;
            _smallBox[1][2]=1;
            _smallBox[1][0]=0;
            _smallBox[2][0]=0;
        }
    }else if(_currentStyle==5)
    {
        if(_smallBox[0][0]==1)
        {
            _smallBox[0][0]=0;
            _smallBox[2][1]=0;
            _smallBox[0][1]=1;
            _smallBox[0][2]=1;
        }
        else
        {
            _smallBox[0][0]=1;
            _smallBox[0][2]=0;
            _smallBox[0][1]=0;
            _smallBox[2][1]=1;
        }

    }
    else
    {
        int temp[3][3];
        for(int row=0;row<3;row++)
        {
            for (int line=0; line<3; line++) {
                temp[row][line]=_smallBox[2-line][row];
            }
        }
        //
        for (int row=0; row<3; row++) {
            for (int line=0; line<3; line++) {
                _smallBox[row][line]=temp[row][line];
            }
        }
    }
    if([self collisionCount] >0)
    {
        memcpy(_smallBox, oldSmall, sizeof(BOOL[4][4]));
        return;
    }
    unsigned int left_o_c = [self leftOutLineCount];
    _smallBox_line += left_o_c;
    if([self collisionCount]>0)
    {
        _smallBox_line -=left_o_c;
        memcpy(_smallBox, oldSmall, sizeof(BOOL[4][4]));
        return;
    }
    unsigned int right_o_c =[self rightOutLineCount];
    _smallBox_line -= right_o_c;
    if([self collisionCount]>0)
    {
        _smallBox_line +=right_o_c;
        memcpy(_smallBox, oldSmall, sizeof(BOOL[4][4]));
        return;
    }
    if([self downOutCount] >0)
    {
        memcpy(_smallBox, oldSmall, sizeof(BOOL[4][4]));
    }
    [self generalData];
    REFRESH_SCREEN;
}
#pragma mark Game Controll
-(void)upKey
{
    if(_inAnimation)
        return;
    if(_gameState != STARTED)
        return;
    [self rotateSmallBox];
    [self generalData];
    REFRESH_SCREEN;
}
-(void)downKey
{
    if(_gameState!=STARTED)
        return;
    _smallBox_row++;
    if([self outCount]> 0||[self collisionCount]>0)
    {
        if([self notShowCount]>0)
        {
            [[SoundTools sharedInstance] playLost];
            [self reset];
            return;
        }
        _smallBox_row--;
        self.score += 10;
        [self fixedSmallBox];
        [self eliminate];
        _smallBox_row=-3;
        _smallBox_line=3;
        [self generalSmallBoxWithStyle:_nextStyle];
        _nextStyle = (arc4random() % 7);
        [self generalData];
        REFRESH_SCREEN;
        return;
    }
    [self generalData];
    REFRESH_SCREEN;
}
-(void)fastDown
{
    if(_gameState != STARTED)
        return;
    while ([self outCount] == 0 && [self collisionCount] ==0) {
        _smallBox_row ++;
    }
    if([self notShowCount]>0)
    {
        [[SoundTools sharedInstance] playLost];
        [self reset];
        return;
    }
    [[SoundTools sharedInstance] playFastDown];
    _smallBox_row--;
    self.score    += 10;
    [self fixedSmallBox];
    [self eliminate];
    _smallBox_row  = -3;
    _smallBox_line = 3;
    [self generalSmallBoxWithStyle:_nextStyle];
    _nextStyle = (arc4random() % 7);
    [self generalData];
    REFRESH_SCREEN;
    return;
}
-(void)leftKey
{
    if(_inAnimation)
        return;
    if(_gameState != STARTED)
        return;
    [[SoundTools sharedInstance] playAction];
    _smallBox_line--;
    if([self leftOutLineCount] > 0 || [self collisionCount] >0)
    {
        _smallBox_line ++;
        return;
    }
    [self generalData];
    REFRESH_SCREEN;
}
-(void)rightKey
{
    if(_inAnimation)
        return;
    if(_gameState != STARTED)
        return;
    [[SoundTools sharedInstance] playAction];
    _smallBox_line++;
    if([self rightOutLineCount] > 0 || [self collisionCount] >0)
    {
        _smallBox_line --;
        return;
    }
    [self generalData];
    REFRESH_SCREEN;
}

-(void)generalSmallBoxWithStyle:(NSUInteger)style
{
    memset(_smallBox, 0, sizeof(BOOL[4][4]));
    switch (style) {
        case 0:
            _currentStyle=0;
            _smallBox[0][1]=1;          //   0
            _smallBox[1][1]=1;          //   0
            _smallBox[2][1]=1;          //   0
            _smallBox[3][1]=1;          //   0
            break;
        case 1:
            _currentStyle=1;
            _smallBox[0][0]=1;           //  0
            _smallBox[1][0]=1;           //  0
            _smallBox[2][0]=1;           //  00
            _smallBox[2][1]=1;
            break;
        case 2:
            _currentStyle=2;
            _smallBox[1][0]=1;           // 000
            _smallBox[1][1]=1;           //  0
            _smallBox[1][2]=1;
            _smallBox[2][1]=1;
            break;
        case 3:
            _currentStyle=3;
            _smallBox[1][1]=1;           // 00
            _smallBox[1][2]=1;           // 00
            _smallBox[2][1]=1;
            _smallBox[2][2]=1;
            break;
        case 4:
            _currentStyle=4;
            _smallBox[0][0]=1;           //  00
            _smallBox[0][1]=1;           //   00
            _smallBox[1][1]=1;
            _smallBox[1][2]=1;
            break;
        case 5:
            _currentStyle=5;
            _smallBox[0][1]=1;           //  00
            _smallBox[0][2]=1;           // 00
            _smallBox[1][0]=1;
            _smallBox[1][1]=1;

            break;
        case 6:
            _currentStyle=6;
            _smallBox[0][1]=1;           //  0
            _smallBox[1][1]=1;           //  0
            _smallBox[2][0]=1;           // 00
            _smallBox[2][1]=1;
            break;
        default:
            break;
    }
}
-(void)start
{
    [_timer setFireDate:[NSDate date]];
    _gameState = STARTED;
    
}
-(void)pause
{
    _gameState=PAUSE;
}
-(void)stop
{
    _gameState=STOP;
}
-(void)pause_resume
{
    if(_gameState  == STOP)
        return;
    if(_gameState  == PAUSE)
    {
        _gameState = STARTED;
        return;
    }
    if(_gameState  == STARTED)
    {
        _gameState = PAUSE;
    }
    REFRESH_SCREEN;
}
-(void)reset
{
    if(_inAnimation)
        return;
    memset(_bigBox, 0, sizeof(BOOL[20][10]));
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Tetris"];
    _smallBox_row  = 3;
    _smallBox_line = -3;
    _gameState     = STOP;
    [_timer setFireDate:[NSDate distantFuture]];
    _line  = 0;
    self.score = 0;
    _level = 1;
    _inAnimation = YES;
    _gameState   = STOP;
    __block NSInteger cur_row    = 19;
    __block BOOL      down_to_up = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t reset_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0,0,queue);
    dispatch_source_set_timer(reset_timer, dispatch_walltime(NULL, 0), 0.05* NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(reset_timer,^{
        if(cur_row > 19 && !down_to_up)
        {
            _inAnimation = NO;
            dispatch_source_cancel(reset_timer);
        }
        else
        {
            if(down_to_up)
            {
                for(int line =0;line <10;line++)
                {
                    _data.matrix[cur_row][line] = 1;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    REFRESH_SCREEN;
                });
                cur_row--;
                if(cur_row < 0)
                {
                    cur_row = 0;
                    down_to_up = NO;
                }
            }
            else
            {
                for(int line =0;line <10;line++)
                {
                    _data.matrix[cur_row][line] = 0;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    REFRESH_SCREEN;
                });
                cur_row++;
            }
        }
       
    });
    dispatch_resume(reset_timer);
}
-(void)generalData
{
    if(!_crazyMode)
    {
        memcpy(_data.matrix, _bigBox, sizeof(BOOL[HEIGHT][WIDTH]));
        for(int row=0;row<4;row++)
        {
            for (int line=0; line<4; line++) {
                if(BE_IN_BOX(row, line))
                {
                    _data.matrix[_smallBox_row+row][_smallBox_line+line]|=_smallBox[row][line];
                }
            }
        }
    }
    else
    {
        memset(_data.matrix, 0, sizeof(BOOL[HEIGHT][WIDTH]));
        for(int row=0;row<4;row++)
        {
            for (int line=0; line<4; line++) {
                if(BE_IN_BOX(row, line))
                {
                    _data.matrix[_smallBox_row+row][_smallBox_line+line]=_smallBox[row][line];
                }
            }
        }
    }
    
}
-(void)mainKeyFun
{
    if(_gameState == STOP)
    {
        [self start];
        return;
    }
    if(_gameState == STARTED)
    {
        [self rotateSmallBox];
    }
}
#pragma mark PSPScreenDataSource
-(BOOL)showLine
{
    return YES;
}
-(BOOL)showNext
{
    return YES;
}
-(unsigned int)highScore
{
    return _high_score;
}
-(unsigned int)score
{
    return _score;
}
-(void)setScore:(unsigned int) _newScore
{
    _score      = _newScore;
    _high_score = _score > _high_score ? _score :_high_score;
    if(_score/3000 +1 > _level && _level > 0) //将要升级
    {
        [[SoundTools sharedInstance] playLevelUp];
    }
    self.level      = (_score / 3000)+1;
}
-(void)setLevel:(unsigned int)_newLevel
{
    if(_newLevel > 9)
        _level = 9;
    else
        _level = _newLevel;
}
-(unsigned int)line
{
    return _line;
}
-(unsigned int)level
{
    return _level;
}
-(struct ScreenData)dataForShow
{
    return _data;
}
-(struct NextScreenData)nextForShow
{
    struct NextScreenData data;
    memset(data.matrix, 0, sizeof(BOOL[2][4]));
    switch (_nextStyle) {
        case 0:
            data.matrix[1][0] = 1;
            data.matrix[1][1] = 1;
            data.matrix[1][2] = 1;
            data.matrix[1][3] = 1;
            break;
        case 1:
            data.matrix[0][0] = 1;
            data.matrix[0][1] = 1;
            data.matrix[0][2] = 1;
            data.matrix[1][0] = 1;
            break;
        case 2:
            data.matrix[0][0] = 1;
            data.matrix[0][1] = 1;
            data.matrix[0][2] = 1;
            data.matrix[1][1] = 1;
            break;
        case 3:
            data.matrix[0][1] = 1;
            data.matrix[0][2] = 1;
            data.matrix[1][1] = 1;
            data.matrix[1][2] = 1;
            break;
        case 4:
            data.matrix[0][0] = 1;
            data.matrix[0][1] = 1;
            data.matrix[1][1] = 1;
            data.matrix[1][2] = 1;
            break;
        case 5:
            data.matrix[0][1] = 1;
            data.matrix[0][2] = 1;
            data.matrix[1][0] = 1;
            data.matrix[1][1] = 1;
            break;
        case 6:
            data.matrix[0][0] = 1;
            data.matrix[1][0] = 1;
            data.matrix[1][1] = 1;
            data.matrix[1][2] = 1;
            break;
        default:
            break;
    }
    return data;
}
-(void)saveState
{
    
    NSMutableDictionary * save_dic = [[NSMutableDictionary alloc] init];
    [save_dic setObject:[NSNumber numberWithInt:self.score] forKey:@"score"];
    [save_dic setObject:[NSNumber numberWithInt:self.line]  forKey:@"line"];
    [save_dic setObject:[NSNumber numberWithInt:self.level] forKey:@"level"];
    [save_dic setObject:[NSNumber numberWithInt:_smallBox_row] forKey:@"smallBox_row"];
    [save_dic setObject:[NSNumber numberWithInt:_smallBox_line] forKey:@"smallBox_line"];
    [save_dic setObject:[NSNumber numberWithInt:self.level] forKey:@"level"];
    [save_dic setObject:[NSData dataWithBytes:_bigBox   length:sizeof(BOOL[20][10])] forKey:@"bigBox"];
    [save_dic setObject:[NSData dataWithBytes:_smallBox length:sizeof(BOOL[4][4])] forKey:@"smallBox"];
    [save_dic setObject:[NSNumber numberWithInt:_nextStyle] forKey:@"nextStyle"];
    [save_dic setObject:[NSNumber numberWithInt:_currentStyle] forKey:@"currentStyle"];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:save_dic];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"Tetris"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_high_score] forKey:@"Tetris_highScore"];
}
-(void)reseverState
{
    _high_score = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Tetris_highScore"] intValue];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Tetris"] != nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"继续" message:@"继续上一次？" delegate:self cancelButtonTitle:@"重开一局" otherButtonTitles: @"继续",nil];
        alert.delegate = self;
        [alert show];
    }
}
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    if(buttonIndex == 1)//继续
    {
        NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Tetris"];
        _score         = [[dic objectForKey:@"score"] intValue];
        _line          = [[dic objectForKey:@"line"] intValue];
        _level         = [[dic objectForKey:@"level"] intValue];
        _nextStyle     = [[dic objectForKey:@"nextStyle"] intValue];
        _currentStyle  = [[dic objectForKey:@"currentStyle"] intValue];
        _smallBox_row  = [[dic objectForKey:@"smallBox_row"] intValue];
        _smallBox_line = [[dic objectForKey:@"smallBox_line"] intValue];
        NSData * bigData =[dic objectForKey:@"bigBox"];
        [bigData getBytes:_bigBox length:sizeof(BOOL[20][10])];
        NSData * smallData = [dic objectForKey:@"smallBox"];
        [smallData getBytes:_smallBox length:sizeof(BOOL[4][4])];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Tetris"];
        [self generalData];
        REFRESH_SCREEN;
    }
    if(buttonIndex == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Tetris"];
    }
}
#pragma mark system notification
-(void)APPWillTerminate
{
    [[PSPGameTetris sharedInstance] saveState];
}
@end
