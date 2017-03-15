//
//  ToDoListTableViewCell.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/12.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "ToDoListTableViewCell.h"

@implementation ToDoListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(12, 12, WIDTH, 20);
        _nameLabel.textColor = RGB(51, 51, 51);
        [self.contentView addSubview:_nameLabel];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(12, _nameLabel.bottom+5, WIDTH, 20);
        _infoLabel.textColor = RGB(122, 122, 122);
        _infoLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}

@end
