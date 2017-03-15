
//
//  ToDoDetailViewController.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/12.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "ToDoDetailViewController.h"
#import "DoneLogModel.h"
#import "ToDoListTableViewCell.h"
#import "LogCollectionContainerView.h"
#import "SHCustomDatePickerView.h"
#import "BlockAlertView.h"

#define Add_Log_Tag 5234
#define Edit_Mark_Tag  8023

@interface ToDoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LogCollectionContainerViewDelegate,SHCustomDatePickerViewDelegate>
{
    UITableView *logTableView;
    LogCollectionContainerView *logCollectView;
    NSMutableArray *datesArray;
    
    NSMutableArray *logArray;
    DoneLogModel *currentLogModel;
    
    NSDate *doneDate;
    
    SHCustomDatePickerView *datePicker;
}
@end

@implementation ToDoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"===== %@",_tid);
    if (_tname) {
        self.title = _tname;
    }
    
    logArray = [[NSMutableArray alloc] init];
    
    logTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH, HEIGHT-UI_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    logTableView.delegate = self;
    logTableView.dataSource = self;
    [self.view addSubview:logTableView];
    logTableView.tableFooterView = [[UIView alloc] init];
    
    datePicker = [[SHCustomDatePickerView alloc] init];
    datePicker.delegate = self;
    datePicker.currentDate = [NSDate date];
    datePicker.withOutLimit = YES;
    
    if ([self.tname rangeOfString:@"次数"].length == 0) {
        datesArray = [[NSMutableArray alloc] init];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"日历" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        logCollectView = [[LogCollectionContainerView alloc] initWithFrame:CGRectMake(0, UI_NAV_BAR_HEIGHT, WIDTH,HEIGHT-UI_NAV_BAR_HEIGHT)];
        logCollectView.logCollectionViewDelegate = self;
        [self.view insertSubview:logCollectView belowSubview:logTableView];
        [logCollectView addSubview:datePicker];
    }else{
        logTableView.top = 0;
        logTableView.height = HEIGHT;
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.view addSubview:datePicker];
    }
    
    [self reloadTableView];
    [self reloadCollectionView];
}

-(void)rightClick:(UIBarButtonItem *)item
{
    NSLog(@"%@",item.title);
    if ([self.tname rangeOfString:@"次数"].length == 0) {
        if ([item.title isEqualToString:@"列表"]) {
            [item setTitle:@"日历"];
            [UIView transitionFromView:logCollectView toView:logTableView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                
            }];
        }else{
            [item setTitle:@"列表"];
            [UIView transitionFromView:logTableView toView:logCollectView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                
            }];
        }
    }else{
        [self selectItemWithDate:[NSDate date]];
    }
}

-(void)selectItemWithDate:(NSDate *)selectedDate
{
    [datePicker showDatePickerView];
    __weak __typeof(self) weakSelf = self;
    datePicker.selectDateString = ^(NSString *dateString){
        NSRange range = [dateString rangeOfString:@":"];
        NSLog(@"%@",[dateString substringFromIndex:range.location+1]);
        NSInteger hour = [[dateString substringToIndex:range.location] integerValue];
        NSInteger minute = [[dateString substringFromIndex:range.location + 1] integerValue];
        
        NSLog(@"%ld--%ld",hour,minute);
        NSLog(@"%@",selectedDate);
        NSDateComponents *comp = [[Tools getCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:selectedDate];
        [comp setHour:hour];
        [comp setMinute:minute+1];
        NSDate *tempDate = [[Tools getCalendar] dateFromComponents:comp];
        NSLog(@"%f",tempDate.timeIntervalSince1970);
        if ([[OperationDB shareOperationDB] insertRecord:@{@"tid":weakSelf.tid,@"done_time":[NSString stringWithFormat:@"%.0f",tempDate.timeIntervalSince1970]} andTableName:Done_Log_Tabel]) {
                    NSLog(@"任务完成");
                    NSArray *doneArray = [[OperationDB shareOperationDB] findSetWithDictionary:@{@"tid":weakSelf.tid} andTableName:Done_Log_Tabel];
                    if ([[OperationDB shareOperationDB] updateKey:@"donedays" toValue:[NSString stringWithFormat:@"%ld",doneArray.count] withParaDict:@{@"tid":weakSelf.tid} andTableName:To_Do_Table]) {
                        NSLog(@"更新完成时间成功！");
                    }
    
                    if ([Tools isTodayWithDate:selectedDate]) {
                        if ([[OperationDB shareOperationDB] updateKey:@"update_time" toValue:[NSString stringWithFormat:@"%.0f",selectedDate.timeIntervalSince1970] withParaDict:@{@"tid":weakSelf.tid} andTableName:To_Do_Table]) {
                            NSLog(@"更新更新时间成功！");
                        }
                    }
                    [weakSelf reloadCollectionView];
                    [weakSelf reloadTableView];
                    if ([weakSelf.delegate respondsToSelector:@selector(logChanged)]) {
                        [weakSelf.delegate logChanged];
                    }
                }
    };
}

-(void)reloadTableView
{
    [logArray removeAllObjects];
    NSArray *array = [[OperationDB shareOperationDB] findSetWithDictionary:@{@"tid":_tid} orderByName:@"done_time" andTableName:Done_Log_Tabel];
    for (int i = 0; i < array.count; i++) {
        DoneLogModel *model = [DoneLogModel mj_objectWithKeyValues:array[i]];
        [logArray addObject:model];
    }
    
    [logTableView reloadData];
}

-(void)reloadCollectionView
{
    [datesArray removeAllObjects];
    NSArray *array = [[OperationDB shareOperationDB] findSetWithDictionary:@{@"tid":_tid} orderByName:@"done_time" andTableName:Done_Log_Tabel];
    for (int i = 0; i < array.count; i++) {
        DoneLogModel *model = [DoneLogModel mj_objectWithKeyValues:array[i]];
        [datesArray addObject:[NSDate dateWithTimeIntervalSince1970:[model.done_time floatValue]]];
    }
    logCollectView.dateArray = datesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return logArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logcell"];
    if (!cell) {
        cell = [[ToDoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logcell"];
    }
    DoneLogModel *model = logArray[indexPath.row];
    cell.nameLabel.text = [Tools getTimeWithSeconds:model.done_time];
    if (model.mark && model.mark.length > 0) {
        cell.infoLabel.text = model.mark;
    }else{
        cell.infoLabel.text = @"无备注";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentLogModel = logArray[indexPath.row];
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"输入备注信息" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.alertViewStyle = UIAlertViewStylePlainTextInput;
    [al textFieldAtIndex:0].placeholder = @"输入备注";
    [al textFieldAtIndex:0].text = currentLogModel.mark;
    al.tag = Edit_Mark_Tag;
    [al show];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentLogModel = logArray[indexPath.row];
    
    BlockAlertView *al = [[BlockAlertView alloc] initWithTitle:@"提示" message:@"你这天真的没完成啊？" delegate:nil cancelButtonTitle:@"点错了" otherButtonTitles:@"没有", nil];
    al.operationBlock = ^(NSInteger buttonIndex){
        
        NSDate *selectedDate = [NSDate dateWithTimeIntervalSince1970:[currentLogModel.done_time floatValue]];
        if (buttonIndex == 1) {
            if ([[OperationDB shareOperationDB] deleteRecordWithDict:@{@"tid":_tid,@"done_time":currentLogModel.done_time} andTableName:Done_Log_Tabel]) {
                NSLog(@"任务完成");
                NSArray *doneArray = [[OperationDB shareOperationDB] findSetWithDictionary:@{@"tid":_tid} andTableName:Done_Log_Tabel];
                if ([[OperationDB shareOperationDB] updateKey:@"donedays" toValue:[NSString stringWithFormat:@"%ld",doneArray.count] withParaDict:@{@"tid":_tid} andTableName:To_Do_Table]) {
                    NSLog(@"更新完成时间成功！");
                }
                
                if ([Tools isTodayWithDate:selectedDate]) {
                    DoneLogModel *model = [doneArray firstObject];
                    NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:[model.done_time floatValue]];
                    if ([[OperationDB shareOperationDB] updateKey:@"update_time" toValue:[NSString stringWithFormat:@"%.0f",firstDate.timeIntervalSince1970] withParaDict:@{@"tid":_tid} andTableName:To_Do_Table]) {
                        NSLog(@"更新更新时间成功！");
                    }
                }
                [self reloadCollectionView];
                [logArray removeObjectAtIndex:indexPath.row];
                [logTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if ([self.delegate respondsToSelector:@selector(logChanged)]) {
                    [self.delegate logChanged];
                }
            }
        }
    };
    al.tag = Add_Log_Tag;
    [al show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Edit_Mark_Tag && buttonIndex == 1) {
        NSString *text = [alertView textFieldAtIndex:0].text;
        if (text && text.length > 0) {
            if ([[OperationDB shareOperationDB] updateKey:@"mark" toValue:text withParaDict:@{@"done_time":currentLogModel.done_time} andTableName:Done_Log_Tabel]) {
                NSLog(@"添加备注成功");
                [self reloadTableView];
            }
        }
    }else if(alertView.tag == Add_Log_Tag && buttonIndex == 1){
        
    }
}

@end
