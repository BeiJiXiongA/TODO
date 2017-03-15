//
//  CustomCollectionViewCell.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/13.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = RGB(200, 200, 200);
        _topLine.frame = CGRectMake(0, 0, self.width, .5);
        [self.contentView addSubview:_topLine];
        
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.frame = CGRectMake(self.width/2-9, frame.size.height/2 - 18, 18, 18);
        _dayLabel.font = [UIFont systemFontOfSize:14];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.textColor = RGB(51, 51, 51);
        _dayLabel.layer.cornerRadius = 9;
        _dayLabel.clipsToBounds = YES;
        [self.contentView addSubview:_dayLabel];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(0, frame.size.height/2, frame.size.width, 24);
        _infoLabel.font = [UIFont systemFontOfSize:10];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = RGB(102, 102, 102);
        _infoLabel.numberOfLines = 2;
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}
@end
