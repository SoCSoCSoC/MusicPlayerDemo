//
//  MusicAudioPlayerTool.m
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "MusicAudioPlayerTool.h"

static NSMutableDictionary *musicPlayerAudioDict;

@implementation MusicAudioPlayerTool


+(NSMutableDictionary *)musicPlayerDict
{
    if (!musicPlayerAudioDict) {
        musicPlayerAudioDict = [NSMutableDictionary dictionary];
    }
    return musicPlayerAudioDict;
}


#pragma mark 根据音乐url 播放音乐
+(AVPlayer *)playMusicWithMusicUrlString:(NSString *)musicUrlString
{
    if (musicUrlString  == nil) {
        NSLog(@"无效的播放路径");
        return nil;
    }
    // 从字典取出播放器
    AVPlayer *player  = [self musicPlayerDict][musicUrlString];
    // 判断字典里面取出的播放器是否为空
    if (player == nil) {
        // 创建新的播放器
        player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:musicUrlString]];
        // 把播放器添加到字典
        [[self musicPlayerDict] setObject:player forKey:musicUrlString];
    }

//    if (player.status != AVPlayerStatusReadyToPlay) {
//        return nil;
//    }

    [player play];
    return player;
}
#pragma mark 根据音乐 url 暂停音乐
+(void)pauseMusicWithMusicUrlString:(NSString *)musicUrlString
{
    if (musicUrlString == nil) {
        return;
    }
    AVPlayer *player = [self musicPlayerDict][musicUrlString];
    // 暂停
    [player pause];
}
#pragma mark 根据音乐 url 停止播放音乐
+(void)stopMusicWithMusicUrlString:(NSString *)musicUrlString
{

    if (musicUrlString == nil) {
        return;
    }
    AVPlayer *player = [self musicPlayerDict][musicUrlString];
    // 暂停
    [player pause];
    // 移除播放器
    [[self musicPlayerDict] removeObjectForKey:musicUrlString];
    player = nil;


}
@end
