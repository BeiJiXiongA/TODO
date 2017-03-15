//
//  CustomView.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/15.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView
-(id)initWith:(void(^)(NSInteger buttonIndex))click;
@end
