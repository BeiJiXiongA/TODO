//
//  ToDoDetailViewController.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/12.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToDoDetailViewControllerDelegate <NSObject>

-(void)logChanged;

@end

@interface ToDoDetailViewController : UIViewController
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *tname;
@property (nonatomic, assign) id<ToDoDetailViewControllerDelegate> delegate;
@end
