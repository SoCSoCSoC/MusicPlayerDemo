//
//  MusicAudioPlayerTool.h
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MusicAudioPlayerTool : NSObject

#pragma mark 根据音乐url 播放音乐
+(AVPlayer *)playMusicWithMusicUrlString:(NSString *)musicUrlString;
#pragma mark 根据音乐 url 暂停音乐
+(void)pauseMusicWithMusicUrlString:(NSString *)musicUrlString;
#pragma mark 根据音乐 url 停止播放音乐
+(void)stopMusicWithMusicUrlString:(NSString *)musicUrlString;
@end
