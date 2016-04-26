//
//  ListViewCell.h
//  MusicProject
//
//  Created by 郭晓敏 on 15/10/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicModel ;

@interface ListViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UILabel *songNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *songAuthorLabel;


@property (strong, nonatomic) IBOutlet UIImageView *playIndicatorImageView;

#pragma mark 设置 cell 
-(void)setCellDataWithModel:(MusicModel *)model;

+(CGFloat)height;

@end
