//
//  MusicPlayViewController.m
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "MusicDataTool.h"
#import "MusicModel.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "LyricCell.h"
#import "LyricModel.h"
@interface MusicPlayViewController ()<UITableViewDataSource, UITableViewDelegate>

// 播放器
@property(nonatomic, strong)AVPlayer *player;
//播放进度的定时器
@property(nonatomic, strong)NSTimer *progressTimer;

// 歌词所在的数组
@property(nonatomic, strong)NSArray *lyricDataArray;

// 记录当前选中的行(歌词)
@property(nonatomic, assign)NSInteger currentSelectRow;


// 歌曲背景大图片
@property (strong, nonatomic) IBOutlet UIImageView *songBackGroundImageView;

//  播放按钮
@property (strong, nonatomic) IBOutlet UIButton *playButton;

// 整个进度条
@property (strong, nonatomic) IBOutlet UIView *ProgressBackGroundView;
// 当前的进度
@property (strong, nonatomic) IBOutlet UIView *currentProgressView;
// 进度条上面的滑竿
@property (strong, nonatomic) IBOutlet UIButton *processThumbButton;
// 当前播放的音乐的模型
@property(nonatomic, strong)MusicModel *currentPlayingMusciModel;
// 总时间的 label
@property (strong, nonatomic) IBOutlet UILabel *musicSumTimeLabel;
//展示歌词的 tableView
@property (strong, nonatomic) IBOutlet UITableView *lyricTableView;
// 转圈的 imageView
@property (strong, nonatomic) IBOutlet UIImageView *rotateImageView;


@end

@implementation MusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置展示歌词的 tableView
    self.lyricTableView.delegate = self;
    self.lyricTableView.dataSource = self;
    self.rotateImageView.layer.cornerRadius = 30;
    self.rotateImageView.clipsToBounds = YES;
}

// 展示播放页面，并且开始播放
-(void)showPlayViewAndStartPlay
{
    // 获取 window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 设置播放页面的大小
    self.view.frame = window.bounds;
    // 将当前控制器的 view 添加 window 上面
    [window addSubview:self.view];
    self.view.hidden = NO;
    // 让 view 从小面跳出来（利用动画实现）
    self.view.y = window.bounds.size.height;

#warning 动画开始的时候应该关闭用户交互。。。在动画结束的时候开启交互
    window.userInteractionEnabled = NO;
    // 执行动画弹出 view
    [UIView animateWithDuration:1.0f animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;

        // 重置数据
        [self resetPlayingMusic];
        self.lyricDataArray = [MusicDataTool currentLyricOfMusic];
        // 刷新歌词
        [self.lyricTableView reloadData];
        // 开始播放
        [self startPlayMusic];

    }];
}


#pragma mark 上一首歌曲按钮点击事件

- (IBAction)previousSongButtonDidClicked:(id)sender {
    // 首先重置数据
    [self resetPlayingMusic];
    // 设置当前需要播放的音乐
    [MusicDataTool setCurrentPlayingMusicWithModel:[MusicDataTool previouesMusicModel]];
    self.lyricDataArray = [MusicDataTool currentLyricOfMusic];
    // 刷新歌词
    [self.lyricTableView reloadData];
    [self removeProgressTimer];
    // 开始音乐的播放
    [self startPlayMusic];
}

#pragma mark 下一首歌曲按钮点击事件
- (IBAction)nextSongButtonDidClicked:(id)sender {
    // 首先重置数据
    [self resetPlayingMusic];
    // 设置当前需要播放的音乐
    [MusicDataTool setCurrentPlayingMusicWithModel:[MusicDataTool nextMusicModel]];
    self.lyricDataArray = [MusicDataTool currentLyricOfMusic];
    // 刷新歌词
    [self.lyricTableView reloadData];
    // 开始音乐的播放
    [self removeProgressTimer];

    [self startPlayMusic];
}
#pragma mark 播放/暂停按钮点击事件

- (IBAction)palyOrPauseButtonDidClicked:(id)sender {

    if ([self.playButton isSelected]) {
        [MusicAudioPlayerTool pauseMusicWithMusicUrlString:self.currentPlayingMusciModel.mp3Url];
        self.playButton.selected = NO;
    }else{
        [MusicAudioPlayerTool playMusicWithMusicUrlString:self.currentPlayingMusciModel.mp3Url];
        self.playButton.selected = YES;
    }
}

#pragma mark 退出按钮点击事件
- (IBAction)quitButtonDidClicked:(id)sender {

    // 拿到 window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 关闭用户交互
    window.userInteractionEnabled = NO;
    // 退出页面动画
    [UIView animateWithDuration:1.0f animations:^{
        self.view.y = window.bounds.size.height;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
        // 开启交互
        window.userInteractionEnabled = YES;
    }];
    // 停止 timer
    [self removeProgressTimer];

}



#pragma mark 播放音乐
-(void)startPlayMusic
{

    // 拿出当前应该播放的音乐
    self.currentPlayingMusciModel = [MusicDataTool currentPlayingMusicModel];
    // 根据地址开始播放音乐
   self.player = [MusicAudioPlayerTool playMusicWithMusicUrlString:self.currentPlayingMusciModel.mp3Url];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicEnded) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 设置播放 button 选中状态
    self.playButton.selected = YES;

    // 设置背景大图
    [self.songBackGroundImageView sd_setImageWithURL:[NSURL URLWithString:self.currentPlayingMusciModel.picUrl] placeholderImage:[UIImage imageNamed:@"musicbackGround@2x.jpg"]];
    // 设置转圈的图片
    [self.rotateImageView sd_setImageWithURL:[NSURL URLWithString:self.currentPlayingMusciModel.picUrl] placeholderImage:[UIImage imageNamed:@"musicbackGround@2x.jpg"]];

    // 设置总时间
    self.musicSumTimeLabel.text = [self stringWithTimeSeconds:self.currentPlayingMusciModel.duration / 1000];
    // 获取进度---开启定时器
    [self addAndstartProgressTimer];

}

#pragma mark 开启定时器
-(void)addAndstartProgressTimer
{
    // 首先更新数据
    [self didNeedUpdateProgress];
    //创建定时器
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(didNeedUpdateProgress) userInfo:nil repeats:YES];
    // 将定时器添加到事件循环
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];

}
#pragma mark 关闭定时器
-(void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
/*
 更新进度的方法
*/
-(void)didNeedUpdateProgress
{
    // 计算进度
    double progress = (self.player.currentTime.value / self.player.currentTime.timescale) / (self.currentPlayingMusciModel.duration / 1000.0);

    // 得到滑块滑动的最大位置
    double thumbMaxSlider = self.view.width - self.processThumbButton.width;
    // 设置滑动块的位置
    self.processThumbButton.x = progress *thumbMaxSlider;

    // 设置滑动区域的大小
    self.currentProgressView.width = self.processThumbButton.centerX;

    // 设置当前播放的时间
    [self.processThumbButton setTitle:[self stringWithTimeSeconds:(self.player.currentTime.value / self.player.currentTime.timescale)] forState:UIControlStateNormal];
    // 开始滚动歌词
    [self rotateLyricWithProgress:(self.player.currentTime.value / self.player.currentTime.timescale) * 1.0f];
    // 开始旋转图片
    [self startRotateImage];

}




#pragma mark 重置播放数据
-(void)resetPlayingMusic
{
    [self.songBackGroundImageView setImage:[UIImage imageNamed:@"musicbackGround@2x.jpg"]];
    // 停止播放器的播放
    [MusicAudioPlayerTool stopMusicWithMusicUrlString:self.currentPlayingMusciModel.mp3Url];
    // 得到歌词
//     self.lyricDataArray = [MusicDataTool currentLyricOfMusic];
    // 将当前选中的行置0
    self.currentSelectRow = 0;

}

#pragma mark 进度条上面点击事件
- (IBAction)ProgresstapGRAction:(id)sender {

    // 先暂停音乐的播放
    // 取出当前点击的位置
    CGPoint point = [sender locationInView:self.ProgressBackGroundView];
    //计算进度
    double progress = (point.x / (self.view.width - self.processThumbButton.width)) * 1.0f * (self.currentPlayingMusciModel.duration / 1000);

    self.processThumbButton.x = point.x;

    if (self.player.status == AVPlayerItemStatusReadyToPlay) {
        // 设置播放事件
        [self.player seekToTime:CMTimeMakeWithSeconds(progress, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
            [self didNeedUpdateProgress];
        }];

    }



}

#pragma mark 进度条上面拖拽事件
- (IBAction)progressPanGRAction:(UIPanGestureRecognizer *)sender {

//获取当前拖拽的位置
    CGPoint ponit = [sender translationInView:sender.view];

//将滑块移动到拖拽的位置
    self.processThumbButton.x += ponit.x;

    [sender setTranslation:CGPointZero inView:sender.view];
    if (self.processThumbButton.x < 0) {
        self.processThumbButton.x = 0;
    }else if (self.processThumbButton.x > (self.view.width - self.processThumbButton.width)){
        self.processThumbButton.x = self.view.width - self.processThumbButton.width;
    }
    self.currentProgressView.width = self.processThumbButton.centerX;

    double progress = (self.processThumbButton.x / (self.view.width - self.processThumbButton.width)) * 1.0f * (self.currentPlayingMusciModel.duration / 1000);


    if (sender.state == UIGestureRecognizerStateBegan) {
        [self removeProgressTimer];
    }

    if (sender.state == UIGestureRecognizerStateEnded) {

        // 设置播放事件
        [self.player seekToTime:CMTimeMakeWithSeconds(progress, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
            [self addAndstartProgressTimer];
            [sender setTranslation:CGPointZero inView:sender.view];
        }];

    }


}



#pragma mark 将事件秒转化为分钟:秒的字符串形式
-(NSString *)stringWithTimeSeconds:(NSTimeInterval)timeSeconds
{
    int m = timeSeconds / 60;
    int s = (int)timeSeconds % 60;
    return [NSString stringWithFormat:@"%02d:%02d",m,s];

}




#pragma mark tabldeView dataSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"LyricCell";
    LyricCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [XIBViewUtil loadViewFromXibName:@"LyricCell"];
    }

    LyricModel *lyricModel = [MusicDataTool currentLyricOfMusic][indexPath.row];
    cell.lyricLabel.text = lyricModel.lyric;
    if (indexPath.row == self.currentSelectRow) {
        cell.lyricLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f];
    }else
    {
        cell.lyricLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    }
    return cell;

}

#pragma mark 滚动歌词
-(void)rotateLyricWithProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger index = 0;
        NSInteger time = (NSInteger)progress;


        for (int i = 0 ; i < self.lyricDataArray.count; i ++) {
            LyricModel *model = self.lyricDataArray[i];
            if (time == model.time) {
                index = i;
            }
        }

        if (index == 0) {
            return;
        }
        
        self.currentSelectRow = index;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.lyricTableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        });
    });


}

#pragma mark 图片旋转
-(void)startRotateImage
{
    self.rotateImageView.transform = CGAffineTransformRotate(self.rotateImageView.transform, M_2_PI / 5);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)musicEnded
{
    [self removeProgressTimer];
    [self.player pause];
//    [self.player seekToTime:CMTimeMakeWithSeconds(0, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
//        [self.player play];
//    }];
}


@end
