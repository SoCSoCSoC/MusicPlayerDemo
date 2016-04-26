//
//  LyricModel.h
//  MusicPlayer_01
//
//  Created by 邹浩 on 15/9/8.
//  Copyright (c) 2015年 蓝鸥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject


@property (nonatomic, copy)NSString *lyric;
@property (nonatomic, assign)int time;

- (instancetype)initWithTime:(int)time WithLyric:(NSString *)lyric;


@end
