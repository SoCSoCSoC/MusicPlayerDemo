//
//  MusicModel.m
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/7.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.songID = [value integerValue];
    }
    if ([key isEqualToString:@"duration"]) {
        self.duration = [value integerValue];
    }
    self.isPlaying = notPlaying;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"%@", key);
}
@end
