//
//  ViewController.m
//  PSP
//
//  Created by 张雨 on 15/5/29.
//  Copyright (c) 2015年 张雨. All rights reserved.
//

#import "ViewController.h"
#import "PSPGameTetris.h"
@interface ViewController ()

@end

@implementation ViewController
#pragma mark viewController life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view     addSubview:self.bg];
    [self.view addSubview:[PSPScreen sharedScreen]];
    [[PSPGameTetris sharedInstance] reseverState];
    ((PSPScreen*)[PSPScreen sharedScreen]).backgroundColor = [UIColor colorWithRed:150/255.0 green:183/255.0 blue:149/255.0 alpha:1.0];
    ((PSPScreen*)[PSPScreen sharedScreen]).dataSource = [PSPGameTetris sharedInstance];
    [self.view addSubview:self.upBtn];
    [self.view addSubview:self.downBtn];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.resetBtn];
    [self.view addSubview:self.ABtn];
    [self.view addSubview:self.pauseBtn];
    [self.view addSubview:self.crazyBtn];
    [self.view addSubview:self.fastDownBtn];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NEEDSDISPLAY" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* note){
        [[PSPScreen sharedScreen] setNeedsDisplay];
    
    }];
    __weak ViewController * weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        [weakSelf.longPressTimer setFireDate:[NSDate distantFuture]];
        _step = 0;
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    BOOL ssss = ([UIScreen mainScreen].bounds.size.width ==320 && [UIScreen mainScreen].bounds.size.height ==480);    //4或者是4s
    unsigned int screenW  = [UIScreen mainScreen].bounds.size.width;
    unsigned int screenH  = [UIScreen mainScreen].bounds.size.height;
    float gameScreenW  = ( (ssss?523.0:1020.0) / self.bg.image.size.width) * screenW;
    float gameScreenH  = ( (ssss?604.0:1178.0) / self.bg.image.size.height)* screenH;
    float gameScreenX  = ( (ssss?59.0 :111.0)  / self.bg.image.size.width) * screenW;
    float gameScreenY  = ( (ssss?50.0 :156.0)  / self.bg.image.size.height)* screenH;
    self.bg.frame = CGRectMake(0, 0, screenW, screenH);
    ((PSPScreen*)[PSPScreen sharedScreen]).transform = CGAffineTransformMakeScale(gameScreenW/260.0, gameScreenW/260.0);
    ((PSPScreen*)[PSPScreen sharedScreen]).frame=CGRectMake( gameScreenX+5, gameScreenY+5, gameScreenW-10,gameScreenH-10);
    float btn_w      = (ssss?60:70) * (screenW/375.0);
    float upPicW     = self.upBtn.imageView.image.size.width;
    float upPicH     = self.upBtn.imageView.image.size.height;
    float downPicW   = self.downBtn.imageView.image.size.width;
    float downPicH   = self.downBtn.imageView.image.size.height;
    float leftPicW   = self.leftBtn.imageView.image.size.width;
    float leftPicH   = self.leftBtn.imageView.image.size.height;
    float rightPicW  = self.rightBtn.imageView.image.size.width;
    float rightPicH  = self.rightBtn.imageView.image.size.height;
    float leftBtbW   = btn_w*(leftPicW/leftPicH);
    float rightBtnW  = btn_w*(rightPicW/rightPicH);
    float upBtnH     = btn_w*(upPicH/upPicW);
    float downBtnH   = btn_w*(downPicH/downPicW);
    float offset_x = gameScreenX;
    float offset_y= (screenH - gameScreenH - gameScreenY -(2*btn_w-(btn_w*(rightPicW/rightPicH)-btn_w) + btn_w*(downPicH/downPicW)))/2 + gameScreenY + gameScreenH;
    
    self.leftBtn.frame  = CGRectMake(offset_x,offset_y+btn_w ,leftBtbW,btn_w);
    self.rightBtn.frame = CGRectMake(self.leftBtn.right+16,offset_y+btn_w, rightBtnW,btn_w);
    self.upBtn.frame    = CGRectMake(self.leftBtn.right+8-btn_w/2.0+0.5 ,self.leftBtn.top+btn_w/2 -8-upBtnH , btn_w, upBtnH);
    self.downBtn.frame  = CGRectMake(self.upBtn.left,self.upBtn.bottom+16, btn_w,downBtnH);
    
    float resetBtnW  = self.resetBtn.imageView.image.size.width;
    float resetBtnH  = self.resetBtn.imageView.image.size.height;
    float pauseBtnW  = self.pauseBtn.imageView.image.size.width;
    float pauseBtnH  = self.pauseBtn.imageView.image.size.height;
    float crazyBtnW  = self.crazyBtn.imageView.image.size.width;
    float crazyBtnH  = self.crazyBtn.imageView.image.size.height;
    float set_btn_w  = 20;
    float set_btn_y  = gameScreenH + gameScreenY + 10;
    
    self.crazyBtn.frame    = CGRectMake(screenW-gameScreenX -set_btn_w, set_btn_y, set_btn_w, set_btn_w*(crazyBtnH/crazyBtnW));
    self.resetBtn.frame    = CGRectMake(ssss?gameScreenX:self.crazyBtn.left-100,set_btn_y, set_btn_w, set_btn_w*(resetBtnH/resetBtnW));
    self.pauseBtn.frame    = CGRectMake(ssss?gameScreenX+gameScreenW/2-10:self.crazyBtn.left-50, set_btn_y, set_btn_w, set_btn_w*(pauseBtnH/pauseBtnW));
    
    float ABtn_w           = (ssss?70:80)*(screenW/375.0);//主键的大小
    self.ABtn.frame        = CGRectMake(self.rightBtn.right+(ssss?20:10),self.leftBtn.center.y-ABtn_w, ABtn_w, ABtn_w);
    self.fastDownBtn.frame = CGRectMake(self.ABtn.center.x,self.leftBtn.center.y, ABtn_w, ABtn_w);
}
#pragma mark  control action
-(void)upKeyDown
{
    [[PSPGameTetris sharedInstance] upKey];
}
-(void)fastDownKeyDown
{
    [[PSPGameTetris sharedInstance] fastDown];
}
-(void)downKeyDown
{
    _step =0;
    _longPress = DownLongPress;
    [[PSPGameTetris sharedInstance] downKey];
    [self.longPressTimer setFireDate:[NSDate date]];
}
-(void)downKeyUpInside
{
    _step = 0;
    [self.longPressTimer setFireDate:[NSDate distantFuture]];
}
-(void)longPressTimerEvent
{
    _step ++;
    if(_step < 7)
        return;
    switch (_longPress) {
        case LeftLongPress:
            [[PSPGameTetris sharedInstance] leftKey];
            break;
        case RightLongPress:
            [[PSPGameTetris sharedInstance] rightKey];
            break;
        case DownLongPress:
            [[PSPGameTetris sharedInstance] downKey];
            break;
        default:
            break;
    }
}
-(void)leftKeyDown
{
    _step =0;
    _longPress = LeftLongPress;
    [[PSPGameTetris sharedInstance] leftKey];
    [self.longPressTimer setFireDate:[NSDate date]];
}
-(void)leftKeyUpInside
{
    _step =0;
    [self.longPressTimer setFireDate:[NSDate distantFuture]];
}
-(void)rightKeyDown
{
    _step = 0;
    _longPress = RightLongPress;
    [[PSPGameTetris sharedInstance] rightKey];
    [self.longPressTimer setFireDate:[NSDate date]];
}
-(void)rightKeyUpInside
{
    _step =0;
    [self.longPressTimer setFireDate:[NSDate distantFuture]];
}
-(void)resetFun
{
    [[PSPGameTetris sharedInstance] reset];
}
-(void)AFun
{
    [[PSPGameTetris sharedInstance] mainKeyFun];
}
-(void)pauseFun
{
    [[PSPGameTetris sharedInstance] pause_resume];
}
-(void)crazyFun
{
    [[PSPGameTetris sharedInstance] setCrazyMode:![[PSPGameTetris sharedInstance] crazyMode]];
}
#pragma mark getter or setter
-(GameButton*)leftBtn
{
    if(_leftBtn == nil)
    {
        _leftBtn = [[GameButton alloc] init];
        [_leftBtn setImage:[UIImage imageNamed:@"方向D"] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"方向D1"] forState:UIControlStateHighlighted];
        [_leftBtn addTarget:self action:@selector(leftKeyUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn addTarget:self action:@selector(leftKeyDown) forControlEvents:UIControlEventTouchDown];
    }
    return _leftBtn;
}
-(UIImageView*)bg
{
    if(_bg == nil)
    {
        _bg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:[UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height ==480?@"BG640960":@"bg"]];
    }
    return _bg;
}
-(GameButton*)rightBtn
{
    if(_rightBtn == nil)
    {
        _rightBtn = [[GameButton alloc] init];
        [_rightBtn setImage:[UIImage imageNamed:@"方向C"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"方向C1"] forState:UIControlStateHighlighted];
        [_rightBtn addTarget:self action:@selector(rightKeyUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(rightKeyDown) forControlEvents:UIControlEventTouchDown];
    }
    return _rightBtn;
}
-(UIButton*)upBtn
{
    if(_upBtn == nil)
    {
        _upBtn = [[UIButton alloc] init];
//        _upBtn.backgroundColor=[UIColor whiteColor];
        [_upBtn setImage:[UIImage imageNamed:@"方向A"] forState:UIControlStateNormal];
        [_upBtn setImage:[UIImage imageNamed:@"方向A1"] forState:UIControlStateHighlighted];
        [_upBtn addTarget:self action:@selector(upKeyDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upBtn;
}
-(UIButton*)downBtn
{
    if(_downBtn == nil)
    {
        _downBtn = [[UIButton alloc] init];
        [_downBtn setImage:[UIImage imageNamed:@"方向B"] forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"方向B1"] forState:UIControlStateHighlighted];
        [_downBtn addTarget:self action:@selector(downKeyDown) forControlEvents:UIControlEventTouchDown];
        [_downBtn addTarget:self action:@selector(downKeyUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downBtn;
}
-(UIButton*)fastDownBtn
{
    if(_fastDownBtn == nil)
    {
        _fastDownBtn = [[UIButton alloc] init];
        [_fastDownBtn setImage:[UIImage imageNamed:@"B按钮"] forState:UIControlStateNormal];
        [_fastDownBtn setImage:[UIImage imageNamed:@"B按钮1"] forState:UIControlStateHighlighted];
        [_fastDownBtn addTarget:self action:@selector(fastDownKeyDown) forControlEvents:UIControlEventTouchDown];
    }
    return _fastDownBtn;
}
-(UIButton*)resetBtn
{
    if(_resetBtn == nil)
    {
        _resetBtn = [[UIButton alloc] init];
        [_resetBtn setImage:[UIImage imageNamed:@"A"] forState:UIControlStateNormal];
        [_resetBtn setImage:[UIImage imageNamed:@"A1"] forState:UIControlStateHighlighted];
        [_resetBtn addTarget:self action:@selector(resetFun) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}
-(UIButton*)ABtn
{
    if(_ABtn == nil)
    {
        _ABtn = [[UIButton alloc] init];
        [_ABtn setImage:[UIImage imageNamed:@"A按钮"] forState:UIControlStateNormal];
        [_ABtn setImage:[UIImage imageNamed:@"A按钮1"] forState:UIControlStateHighlighted];
        [_ABtn addTarget:self action:@selector(AFun) forControlEvents:UIControlEventTouchUpInside];
        [_ABtn setTitle:@"A" forState:UIControlStateNormal];
    }
    return  _ABtn;
}
-(UIButton*)pauseBtn
{
    if(_pauseBtn == nil)
    {
        _pauseBtn = [[UIButton alloc] init];
        [_pauseBtn setImage:[UIImage imageNamed:@"B"] forState:UIControlStateNormal];
        [_pauseBtn setImage:[UIImage imageNamed:@"B1"] forState:UIControlStateHighlighted];
        [_pauseBtn addTarget:self action:@selector(pauseFun) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseBtn;
}
-(UIButton*)crazyBtn
{
    if(_crazyBtn == nil)
    {
        _crazyBtn = [[UIButton alloc] init];
        [_crazyBtn setImage:[UIImage imageNamed:@"C"] forState:UIControlStateNormal];
        [_crazyBtn setImage:[UIImage imageNamed:@"C1"] forState:UIControlStateHighlighted];
        [_crazyBtn addTarget:self action:@selector(crazyFun) forControlEvents:UIControlEventTouchUpInside];
        [_crazyBtn setTitle:@"Crazy" forState:UIControlStateNormal];
    }
    return _crazyBtn;
}
-(NSTimer*)longPressTimer
{
    if(_longPressTimer == nil)
    {
        _longPressTimer =[NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(longPressTimerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_longPressTimer forMode:NSDefaultRunLoopMode];
        [_longPressTimer fire];
    }
    return _longPressTimer;
}
@end
