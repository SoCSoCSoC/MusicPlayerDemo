//
//  XIBViewUtil.m
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "XIBViewUtil.h"
#import <UIKit/UIKit.h>
@implementation XIBViewUtil
+(id)loadViewFromXibName:(NSString *)xibName
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    if (array && [array count]) {
        return array[0];
    }else {
        return nil;
    }
}

@end
