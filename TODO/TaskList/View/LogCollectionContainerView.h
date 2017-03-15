//
//  LogCollectionView.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/12.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogCollectionContainerViewDelegate <NSObject>

-(void)selectItemWithDate:(NSDate *)selectedDate;

@end

@interface LogCollectionContainerView : UIView
@property (nonatomic, strong) NSArray *dateArray;
@property (nonatomic, assign) id<LogCollectionContainerViewDelegate> logCollectionViewDelegate;
@end
