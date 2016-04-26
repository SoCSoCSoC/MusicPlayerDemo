//
//  LyricModel.m
//  MusicPlayer_01
//
//  Created by 邹浩 on 15/9/8.
//  Copyright (c) 2015年 蓝鸥. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

- (instancetype)initWithTime:(int)time WithLyric:(NSString *)lyric
{
    if (self = [super init]) {
        self.time = time;
        self.lyric = lyric;
    }
    return self;
}
@end
