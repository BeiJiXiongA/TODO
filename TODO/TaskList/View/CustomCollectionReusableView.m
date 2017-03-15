//
//  CustomCollectionReusableView.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/13.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "CustomCollectionReusableView.h"

@implementation CustomCollectionReusableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = RGB(122, 122, 122);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
