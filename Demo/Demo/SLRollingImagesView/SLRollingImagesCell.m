//
//  SLRollingImagesCell.m
//  Demo
//
//  Created by SL🐰鱼子酱 on 15/6/14.
//  Copyright © 2015年 SL. All rights reserved.
//

#import "SLRollingImagesCell.h"


@implementation SLRollingImagesCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [self.contentView addSubview:imageView];
        
        UILabel * detailLabel = [[UILabel alloc] init];
        _detailLabel = detailLabel;
        [self.contentView addSubview:detailLabel];
    }
    return self;
}

static const float kLabelHeight = 20;

- (void)layoutIfNeeded {
    
    self.imageView.frame = self.contentView.frame;
    
    self.detailLabel.frame = CGRectMake(0, self.contentView.bounds.size.height - kLabelHeight, self.contentView.bounds.size.width, kLabelHeight);
    self.detailLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    
}
@end