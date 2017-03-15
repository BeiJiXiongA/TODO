
//
//  BlockAlertView.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/15.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "BlockAlertView.h"

@implementation BlockAlertView
-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (_operationBlock) {
        _operationBlock(buttonIndex);
    }
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}
@end
