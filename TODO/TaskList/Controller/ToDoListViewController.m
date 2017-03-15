//
//  ToDoListViewController.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/7.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ToDoModel.h"
#import "ToDoListTableViewCell.h"
#import "ToDoDetailViewController.h"

#define Add_Alert_Tag  2321
#define Edit_Name_Tag  7239

@interface ToDoListViewController ()<UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
UIActionSheetDelegate,
ToDoDetailViewControllerDelegate>
{
    UITableView *toDoListTableView;
    NSMutableArray *toDoArray;
    
    ToDoModel *currentModel;
}
@end

@implementation ToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"任务列表";
    
    NSLog(@"%@",[NSTimeZone knownTimeZoneNames]);
    
    toDoArray = [[NSMutableArray alloc] init];
    
    toDoListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , HEIGHT) style:UITableViewStylePlain];
    toDoListTableView.backgroundColor = [UIColor whiteColor];
    toDoListTableView.delegate = self;
    toDoListTableView.dataSource = self;
    [self.view addSubview:toDoListTableView];
    
    toDoListTableView.tableFooterView = [[UIView alloc] init];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)];
    self.navigationItem.rightBarButtonItem = addItem;

    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTask
{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"输入任务名称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.alertViewStyle = UIAlertViewStylePlainTextInput;
    [al textFieldAtIndex:0].placeholder = @"输入任务名称";
    al.tag = Add_Alert_Tag;
    [al show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Add_Alert_Tag) {
        if (buttonIndex == 1) {
            NSString *text = [alertView textFieldAtIndex:0].text;
            if (text && text.length > 0) {
                NSDate *nowDate = [NSDate date];
                NSLog(@"-----%f",nowDate.timeIntervalSince1970);
                if ([[OperationDB shareOperationDB] insertRecord:@{@"tname":text,@"create_time":[NSString stringWithFormat:@"%.0f",nowDate.timeIntervalSince1970],@"update_time":@"0",@"havedonetoday":@"0",@"donedays":@"0"} andTableName:To_Do_Table]) {
                    [self refreshData];
                }
            }else{
                [self addTask];
            }
        }
    }else if(alertView.tag == Edit_Name_Tag){
        NSString *text = [alertView textFieldAtIndex:0].text;
        if (text && text.length > 0 && [[OperationDB shareOperationDB] updateKey:@"tname" toValue:text withParaDict:@{@"tid":currentModel.tid} andTableName:To_Do_Table]) {
            NSLog(@"更新任务名称成功！");
            [self refreshData];
        }
    }
}

-(void)refreshData
{
    [toDoArray removeAllObjects];
    NSArray *data = [[OperationDB shareOperationDB] findSetWithDictionary:@{} orderByName:@"create_time" andTableName:To_Do_Table];
    for (int i = 0; i < data.count; i++) {
        NSDictionary *dict = data[i];
        [toDoArray addObject:[ToDoModel mj_objectWithKeyValues:dict]];
    }
    [toDoListTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return toDoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todocell"];
    if (!cell) {
        cell = [[ToDoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"todocell"];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    ToDoModel *model = toDoArray[indexPath.row];
    cell.nameLabel.text = model.tname;
    if ([self haveDoneToday:model]) {
        cell.infoLabel.text = [NSString stringWithFormat:@"今日已完成，已坚持%@天",model.donedays];
        cell.infoLabel.textColor = RGB(122, 122, 122);
    }else{
        cell.infoLabel.text = [NSString stringWithFormat:@"今日未完成，已坚持%@天",model.donedays];
        cell.infoLabel.textColor = [UIColor redColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentModel = toDoArray[indexPath.row];
    
    if ([self haveDoneToday:currentModel]) {
        UIActionSheet *sh = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑名称", nil];
        [sh showInView:self.view];

    }else{
        UIActionSheet *sh = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"完成任务",@"编辑名称", nil];
        [sh showInView:self.view];

    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDoModel *model = toDoArray[indexPath.row];
    if ([[OperationDB shareOperationDB] deleteRecordWithDict:@{@"tid":model.tid} andTableName:To_Do_Table]) {
        NSLog(@"删除成功！");
    }
    [toDoArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessory button tapped ");
    ToDoModel *model = toDoArray[indexPath.row];
    ToDoDetailViewController *toDoDetailVC = [[ToDoDetailViewController alloc] init];
    toDoDetailVC.delegate = self;
    toDoDetailVC.tid = model.tid;
    toDoDetailVC.tname = model.tname;
    [self.navigationController pushViewController:toDoDetailVC animated:YES];
}

-(void)logChanged
{
    [self refreshData];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"完成任务"]) {
        NSDate *nowDate = [NSDate date];
        NSLog(@"=====%@",[NSString stringWithFormat:@"%.0f",nowDate.timeIntervalSince1970]);
        if ([[OperationDB shareOperationDB] insertRecord:@{@"tid":currentModel.tid,@"done_time":[NSString stringWithFormat:@"%.0f",nowDate.timeIntervalSince1970]} andTableName:Done_Log_Tabel]) {
            NSLog(@"任务完成");
            if ([[OperationDB shareOperationDB] updateKey:@"update_time" toValue:[NSString stringWithFormat:@"%.0f",nowDate.timeIntervalSince1970] withParaDict:@{@"tid":currentModel.tid} andTableName:To_Do_Table]) {
                NSLog(@"更新更新时间成功！");
                NSArray *logArray = [[OperationDB shareOperationDB] findSetWithDictionary:@{@"tid":currentModel.tid} andTableName:Done_Log_Tabel];
                if ([[OperationDB shareOperationDB] updateKey:@"donedays" toValue:[NSString stringWithFormat:@"%lu",(unsigned long)logArray.count] withParaDict:@{@"tid":currentModel.tid} andTableName:To_Do_Table]) {
                    NSLog(@"更新完成时间成功！");
                    [self refreshData];
                }
                
            }
        }
    }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"编辑名称"]){
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"编辑任务名称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.alertViewStyle = UIAlertViewStylePlainTextInput;
        [al textFieldAtIndex:0].placeholder = @"输入新的任务名称";
        [al textFieldAtIndex:0].text = currentModel.tname;
        al.tag = Edit_Name_Tag;
        [al show];

    }
}

-(BOOL)haveDoneToday:(ToDoModel *)model
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:[model.update_time floatValue]];
    
    if ([[formatter stringFromDate:nowDate] isEqualToString:[formatter stringFromDate:tempDate]]) {
        return YES;
    }
    return NO;
}

@end
