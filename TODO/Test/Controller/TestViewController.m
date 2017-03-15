//
//  TestViewController.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/13.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "TestViewController.h"
#import "LogCollectionContainerView.h"

#import "CustomView.h"
#import "CustomCollectionViewCell.h"

@interface TestViewController ()
{
    LogCollectionContainerView *demoCollectView;
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    demoCollectView = [[LogCollectionContainerView alloc] initWithFrame:CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, HEIGHT-UI_NAV_BAR_HEIGHT)];
    [self.view addSubview:demoCollectView];
}


@end
