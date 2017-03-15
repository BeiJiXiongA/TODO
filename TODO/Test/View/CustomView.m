//
//  CustomView.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/15.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()
{
    id doneOperation;
    id cancelOperation;
}
@end

@implementation CustomView

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)showAlertTitle:(NSString *)title message:(NSString *)message cancelOperation:(void(^)(NSInteger buttonIndex))cancelBlock doneOperation:(void(^)(NSInteger buttonIndex))doneBlock
{
    
}

@end
