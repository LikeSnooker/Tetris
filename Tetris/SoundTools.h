//
//  SoundTools.h
//  Tetris
//
//  Created by 张雨 on 16/1/19.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SoundTools : NSObject<AVAudioPlayerDelegate>
{
//    AVAudioPlayer * player;
}
+(id)sharedInstance;
-(void)playBG;
-(void)playRotation;
-(void)playDown;
-(void)playDelete1;
-(void)playDelete2;
-(void)playDelete3;
-(void)playDelete4;
-(void)playAction;
-(void)playLost;
-(void)playLevelUp;
-(void)playFastDown;
@end
