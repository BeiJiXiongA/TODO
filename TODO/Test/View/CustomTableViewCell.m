

//
//  CustomTableViewCell.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/14.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell ()
{
    
}
@end

@implementation CustomTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        _bgView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _bgView.userInteractionEnabled = YES;
        [_bgView addSubview:_bgView];
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.contentView];
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
    }else if (pan.state == UIGestureRecognizerStateBegan){
        
    }
}
@end
