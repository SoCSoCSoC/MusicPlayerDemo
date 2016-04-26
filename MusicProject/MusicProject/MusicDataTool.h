//
//  MusicDataTool.h
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/7.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;
@interface MusicDataTool : NSObject

// 获取所有的音乐
+(NSArray *)allMusics;

// 获取当前正在播放的音乐
+(MusicModel *)currentPlayingMusicModel;

// 获取下一首音乐
+(MusicModel *)nextMusicModel;

//获取上一首音乐
+(MusicModel *)previouesMusicModel;

// 设置当前播放的音乐
+(void)setCurrentPlayingMusicWithModel:(MusicModel *)model;


// 获取当前音乐的歌词
+(NSArray *)currentLyricOfMusic;
@end
