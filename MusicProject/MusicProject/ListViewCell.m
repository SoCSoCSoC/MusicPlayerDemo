//
//  ListViewCell.m
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import "ListViewCell.h"
#import "UIImageView+WebCache.h"
#import "MusicModel.h"
#import "UIImage+GIF.h"
@implementation ListViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headerImageView.layer.cornerRadius = 50;
    self.headerImageView.clipsToBounds = YES;
    self.playIndicatorImageView.clipsToBounds = YES;
    self.playIndicatorImageView.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 设置 cell
-(void)setCellDataWithModel:(MusicModel *)model
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"loading_1@2x.png"]];
    self.songNameLabel.text = model.name;
    self.songAuthorLabel.text = model.singer;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"gif"];
    [self.playIndicatorImageView sd_setImageWithURL:[NSURL fileURLWithPath:path]];
    if (model.isPlaying == playing) {
        self.playIndicatorImageView.hidden = NO;
    }else{
        self.playIndicatorImageView.hidden = YES;
    }
}
+(CGFloat)height
{
    return 120;
}
@end
