

//
//  LogTableViewContainer.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/14.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "LogTableViewContainer.h"

@interface LogTableViewContainer ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *logTableView;
    NSArray *dataArray;
}

@end

@implementation LogTableViewContainer

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dataArray = @[@"1",@"2"];
        
        logTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        logTableView.delegate = self;
        logTableView.dataSource = self;
        [self addSubview:logTableView];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
