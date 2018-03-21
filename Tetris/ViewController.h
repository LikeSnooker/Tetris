//
//  ViewController.h
//  PSP
//
//  Created by 张雨 on 15/5/29.
//  Copyright (c) 2015年 张雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPScreen.h"
#import "PSPGame.h"
#import "SoundTools.h"
#import "UIViewExt.h"
#import "GameButton.h"
@interface ViewController : UIViewController

{
    enum longPress
    {
        LeftLongPress,
        RightLongPress,
        DownLongPress
    };
    GameButton  *_leftBtn;
    GameButton  *_rightBtn;
    UIButton  *_upBtn;
    UIButton  *_downBtn;
    UIButton  *_fastDownBtn;
    UIButton  *_resetBtn; //重启按钮
    UIButton  *_ABtn;     //主按钮
    UIButton  *_pauseBtn; //暂停|继续按钮
    UIButton  *_crazyBtn;
    NSTimer   *_longPressTimer; //长按的时候实现方块速降
    UIImageView *_bg;
    unsigned int _step;
    enum longPress  _longPress;
}
@end

