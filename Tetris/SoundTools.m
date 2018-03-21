//
//  SoundTools.m
//  Tetris
//
//  Created by 张雨 on 16/1/19.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import "SoundTools.h"

@implementation SoundTools
static SoundTools     * _instance;
static NSDictionary   * _dic;
static NSMutableArray * _players;
+(id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instance = [[super allocWithZone:NULL] init];
        _dic      = [[NSMutableDictionary alloc] init];
        _players  = [[NSMutableArray alloc] init];
        [_dic setValue:[_instance generalPlayerByMusicName:@"gameBg"] forKey:@"bg_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"rotation"] forKey:@"rotation_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"down"] forKey:@"down_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"delete1"] forKey:@"delete1_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"delete2"] forKey:@"delete2_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"delete3"] forKey:@"delete3_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"delete4"] forKey:@"delete4_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"action"] forKey:@"action_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"levelUp"] forKey:@"levelup_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"lost"]    forKey:@"lost_player"];
        [_dic setValue:[_instance generalPlayerByMusicName:@"fastDown"] forKey:@"fastDown_player"];
    });
    return _instance;
}
-(AVAudioPlayer*)generalPlayerByMusicName:(NSString*)name
{
    NSBundle * bundel = [NSBundle mainBundle];
    NSString * path   = [bundel pathForResource:name ofType:@"mp3"];
    NSData * data     = [[NSData alloc] initWithContentsOfFile:path];
    AVAudioPlayer* player  = [[AVAudioPlayer alloc] initWithData:data error:nil];
    player.volume        = 1.0;
    player.pan           = 0;
    player.numberOfLoops = 0;
    player.currentTime   = 0.0;
    player.delegate      = self;
    [player prepareToPlay];
    return player;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [[self class] sharedInstance];
}
+(id) copyWithZone: (struct _NSZone*)zone
{
    return [[self class] sharedInstance];
}
-(void)playBG
{
    [(AVAudioPlayer*)[_dic objectForKey:@"bg_player"] play];
}
-(void)playRotation
{
    AVAudioPlayer * player = [[SoundTools sharedInstance] generalPlayerByMusicName:@"rotation"];
    [_players addObject:player];
    [player play];
}
-(void)playDown
{
    [(AVAudioPlayer*)[_dic objectForKey:@"down_player"] setCurrentTime:0.0];
    [(AVAudioPlayer*)[_dic objectForKey:@"down_player"] play];
}
-(void)playFastDown
{
    [(AVAudioPlayer*)[_dic objectForKey:@"fastDown_player"] setCurrentTime:0.0];
    [(AVAudioPlayer*)[_dic objectForKey:@"fastDown_player"] play];
}
-(void)playDelete1
{
    [(AVAudioPlayer*)[_dic objectForKey:@"delete1_player"] setCurrentTime:0.0];
    [(AVAudioPlayer*)[_dic objectForKey:@"delete1_player"] play];
}
-(void)playDelete2
{
    [(AVAudioPlayer*)[_dic objectForKey:@"delete2_player"] setCurrentTime:0.0];
    [(AVAudioPlayer*)[_dic objectForKey:@"delete2_player"] play];
}
-(void)playDelete3
{
    [(AVAudioPlayer*)[_dic objectForKey:@"delete3_player"] setCurrentTime:0.0];
    [(AVAudioPlayer*)[_dic objectForKey:@"delete3_player"] play];
}
-(void)playDelete4
{
    [(AVAudioPlayer*)[_dic objectForKey:@"delete4_player"] setCurrentTime:0.0];
    [(AVAudioPlayer*)[_dic objectForKey:@"delete4_player"] play];
}
-(void)playAction
{
    AVAudioPlayer * player = [[SoundTools sharedInstance] generalPlayerByMusicName:@"action"];
    [_players addObject:player];
    [player play];
}
-(void)playLost
{
    [(AVAudioPlayer*)[_dic objectForKey:@"lost_player"] setCurrentTime:0.0];
    [(AVAudioPlayer*)[_dic objectForKey:@"lost_player"] play];
}
-(void)playLevelUp
{
    [(AVAudioPlayer*)[_dic objectForKey:@"levelup_player"] setCurrentTime:0.0];
    [(AVAudioPlayer*)[_dic objectForKey:@"levelup_player"] play];
}
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_players removeObject:player];
}
@end
