//
//  MusicDataTool.m
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/7.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "MusicDataTool.h"
#import "MusicModel.h"
#import "help.h"
#import "LyricModel.h"

// 用来记录正在播放的音乐
MusicModel *_playingMusicModel;

// 存放所有的音乐
static NSArray *_musicsArray;
// 存放当前音乐的歌词
static NSMutableArray *_currentLyricArray;

@implementation MusicDataTool
// 获取所有的音乐
+(NSArray *)allMusics
{
    if (!_musicsArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            NSURL *url = [NSURL URLWithString:k_music_url];
            NSArray *array = [NSArray arrayWithContentsOfURL:url];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                MusicModel *model = [[MusicModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [mutableArray addObject:model];
            }
            _musicsArray = [NSArray arrayWithArray:mutableArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:k_musicListDidPrepared object:nil];
            });
        });
    }
    return _musicsArray;
}

// 获取当前正在播放的音乐
+(MusicModel *)currentPlayingMusicModel
{
    return _playingMusicModel;
}

// 获取下一首音乐
+(MusicModel *)nextMusicModel
{
    // 获取当前播放音乐的索引
    NSInteger index = [[self allMusics] indexOfObject:_playingMusicModel];
    // 计算下一首的索引
    NSInteger nextIndex = index +1;
    // 越界处理--如果是最后一首，则播放第一首
    if (nextIndex >= [self allMusics].count) {
        nextIndex = 0;
    }
    return [self allMusics][nextIndex];

}

//获取上一首音乐
+(MusicModel *)previouesMusicModel
{
    // 获取当前播放音乐的索引
    NSInteger index = [[self allMusics] indexOfObject:_playingMusicModel];
    // 计算下一首的索引
    NSInteger preIndex = index - 1;
    // 越界处理--如果是第一，则播放最后一首
    if (preIndex < 0) {
        preIndex = [self allMusics].count - 1;
    }
    return [self allMusics][preIndex];
    
}



// 设置当前播放的音乐
+(void)setCurrentPlayingMusicWithModel:(MusicModel *)model
{
    if (model && [[self allMusics] containsObject:model]) {
        if (_playingMusicModel) {
            // 前面的歌曲设置为不是正在播放
            _playingMusicModel.isPlaying = notPlaying;
        }
        _playingMusicModel = model;
        NSInteger index = [[self allMusics] indexOfObject:model];
        model.isPlaying = playing;
        [[NSNotificationCenter defaultCenter] postNotificationName:k_musicIsPlaying object:[NSNumber numberWithInteger:index]];
    }
}


+(NSMutableArray *)currentLyricArray
{
    if (!_currentLyricArray) {
        _currentLyricArray  = [NSMutableArray array];
    }
    return _currentLyricArray;
}

// 获取当前音乐的歌词
+(NSArray *)currentLyricOfMusic
{
    // 先移除所有歌词
    [[self currentLyricArray] removeAllObjects];
    NSArray *array = [_playingMusicModel.lyric componentsSeparatedByString:@"\n"];
    for (NSString *str in array) {
        NSArray *arr = [str componentsSeparatedByString:@"]"];
        NSString *lyric = arr.lastObject;
        if (lyric.length == 0) {
            continue;
        }
        NSString *time = [(NSString *)arr.firstObject substringFromIndex:1];
        NSArray *timeArr = [time componentsSeparatedByString:@":"];
        float floatTime = [(NSString *)timeArr[0] floatValue] *60 + [(NSString *)timeArr[timeArr.count-1] floatValue];
        int intTime = (int)floatTime;

        LyricModel *model = [[LyricModel alloc] initWithTime:intTime WithLyric:lyric];
        [[self currentLyricArray] addObject:model];
    }
    return [self currentLyricArray];

}


@end
