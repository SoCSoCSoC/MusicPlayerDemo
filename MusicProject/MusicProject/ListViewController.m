//
//  ListViewController.m
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/7.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "ListViewController.h"
#import "MusicDataTool.h"
#import "help.h"
#import "ListViewCell.h"
#import "MusicPlayViewController.h"
@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate>
// 展现播放列表
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

// 播放页面的控制器

@property(nonatomic, strong)MusicPlayViewController *playMusicVC;

@end

@implementation ListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_musicListDidPrepared object:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音乐列表";
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicListDataDidReceived:) name:k_musicListDidPrepared object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicDidPlaying:) name:k_musicIsPlaying object:nil];
    [self.mainTableView showProgressHUDWithLabelText:@"别急嘛" withAnimated: YES isNeedTransform:NO];
    
}

#pragma mark numbers
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MusicDataTool allMusics].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"ListViewCell";
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [XIBViewUtil loadViewFromXibName:@"ListViewCell"];
    }
    MusicModel *model = [[MusicDataTool allMusics] objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    return cell;
    
}
#pragma mark 选中 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [self.mainTableView deselectRowAtIndexPath:indexPath animated:YES];


    MusicModel *currentMusic = [MusicDataTool allMusics][indexPath.row];
    // 设置当前播放音乐
    [MusicDataTool setCurrentPlayingMusicWithModel:currentMusic];

    // 播放音乐
    [self.playMusicVC showPlayViewAndStartPlay];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ListViewCell height];
}

#pragma mark 如果是第一次，需要网络解析数据，解析完成之后发送通知
-(void)musicListDataDidReceived:(NSNotification *)sender
{
    [self.mainTableView hideProgressHUDWithAnimated:YES];
    [self.mainTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 懒加载

-(MusicPlayViewController *)playMusicVC
{
    if (!_playMusicVC) {
        _playMusicVC = [[MusicPlayViewController alloc] init];
    }
    return _playMusicVC;

}

#pragma mark 某一首歌曲正在播放
-(void)musicDidPlaying:(NSNotification *)sender
{
    [self.mainTableView reloadData];
}

@end
