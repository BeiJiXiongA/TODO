//
//  BlockAlertView.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/15.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockAlertView : UIAlertView
@property (nonatomic, copy) void(^operationBlock)(NSInteger buttonIndex); ;
@end
