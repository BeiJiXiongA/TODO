//
//  ToDoModel.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/12.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoModel : NSObject
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *havedonetoday;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *tname;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *donedays;
@end
