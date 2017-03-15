//
//  OperationDB.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/11.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "OperationDB.h"

static OperationDB *operationDB = nil;

@implementation OperationDB

+(id)shareOperationDB
{
    @synchronized (operationDB) {
        if (!operationDB) {
            operationDB = [[OperationDB alloc] init];
        }
        return operationDB;
    }
}

-(id)init
{
    self = [super init];
    if (self)
    {
        _db = [DBManager defaultDBManager].dataBase;
        [self createToDoTabel];
        [self createDoneLogTable];
    }
    return self;
}

-(void)createToDoTabel
{
    FMResultSet *set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",To_Do_Table]];
    [set next];
    
    NSInteger count = [set intForColumn:0];
    BOOL existTable = !!count;
    if (existTable)
    {
        {
//            DDLOG(@"table To_Do_Table has exist!");
        }
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (tid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,tname VARCHAR(20),create_time VARCHAR(20),update_time VARCHAR(20),havedonetoday VARCHAR(6),donedays VARCHAR(6))",To_Do_Table];
        BOOL res = [_db executeUpdate:sql];
        if (!res)
        {
//            DDLOG(@"table To_Do_Table create failed!");
        }
        else
        {
            DDLOG(@"table To_Do_Table create success!");
        }
    }
}

-(void)createDoneLogTable
{
    FMResultSet *set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",Done_Log_Tabel]];
    [set next];
    
    NSInteger count = [set intForColumn:0];
    BOOL existTable = !!count;
    if (existTable){
//        DDLOG(@"table Done_Log_Tabel has exist!");
    }else{
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (done_time INTEGER PRIMARY KEY,tid VARCHAR(20),mark VARCHAR(20))",Done_Log_Tabel];
        BOOL res = [_db executeUpdate:sql];
        if (!res){
//            DDLOG(@"table Done_Log_Tabel create failed!");
        }else{
            DDLOG(@"table Done_Log_Tabel create success!");
        }
    }

}

#pragma mark - 增

-(BOOL)insertRecord:(NSDictionary *)dict andTableName:(NSString *)tableName
{
    NSMutableString *query = [NSMutableString stringWithFormat:@"INSERT INTO %@",tableName];
    NSMutableString *keys = [NSMutableString stringWithFormat:@" ( "];
    NSMutableString *values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in dict)
    {
        [keys appendString:[NSString stringWithFormat:@"%@,",key]];
        [values appendString:@"?,"];
        [arguments addObject:[dict objectForKey:key]];
    }
    
    [keys appendString:@") "];
    [values appendString:@") "];
    [query appendFormat:@" %@ VALUES %@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    if ([_db executeUpdate:query withArgumentsInArray:arguments])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 删

-(BOOL)deleteRecordWithDict:(NSDictionary *)dict andTableName:(NSString *)tableName
{
    NSMutableString *query = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"DELETE FROM %@ WHERE",tableName]];
    for (NSString *key in dict){
        [query insertString:[NSString stringWithFormat:@" %@='%@' and",key,[dict objectForKey:key]] atIndex:[query length]];
    }
    NSString *queryStr = [query substringToIndex:[query length]-3];
    //    DDLOG(@"queryStr %@",queryStr);
    BOOL success = [_db executeUpdate:queryStr];
    if (success){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 改
-(BOOL)updateKey:(NSString *)key toValue:(NSString *)value
    withParaDict:(NSDictionary *)dict
    andTableName:(NSString *)tableName
{
    NSMutableString *query = [NSMutableString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE",tableName,key,value];
    for (NSString *key in dict){
        [query appendString:[NSString stringWithFormat:@" %@='%@' and",key,[dict objectForKey:key]]];
    }
    NSString *queryStr = [query substringToIndex:[query length]-3];
    BOOL success = [_db executeUpdate:queryStr];
    if (success){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 查
-(NSMutableArray *)findSetWithKey:(NSString *)key
                         andValue:(NSString *)value
                     andTableName:(NSString *)tableName
{
    NSMutableArray *msgArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableString *query = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",tableName,key,value];
    FMResultSet *resultSet = [_db executeQuery:query];
    while ([resultSet next]){
        [msgArray addObject:[resultSet resultDictionary]];
    }
    return msgArray;
}

-(NSMutableArray *)findSetWithDictionary:(NSDictionary *)dict
                            andTableName:(NSString *)tableName
{
    NSMutableArray *msgArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableString *query = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ",tableName];
    if([dict count] > 0){
        [query insertString:@" WHERE" atIndex:[query length]];
        for (NSString *key in dict){
            [query appendString:[NSString stringWithFormat:@" %@='%@' and",key,[dict objectForKey:key]]];
        }
        [query deleteCharactersInRange:NSMakeRange([query length]-3, 3)];
    }
    FMResultSet *resultSet = [_db executeQuery:query];
    while ([resultSet next]){
        [msgArray addObject:[resultSet resultDictionary]];
    }
    return msgArray;
}

-(NSMutableArray *)findSetWithDictionary:(NSDictionary *)dict
                             orderByName:(NSString *)orderKey
                            andTableName:(NSString *)tableName
{
    NSMutableArray *msgArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableString *query = [NSMutableString stringWithFormat:@"SELECT * FROM %@ ",tableName];
    if([dict count] > 0){
        [query insertString:@" WHERE" atIndex:[query length]];
        for (NSString *key in dict){
            [query appendString:[NSString stringWithFormat:@" %@='%@' and",key,[dict objectForKey:key]]];
        }
        [query deleteCharactersInRange:NSMakeRange([query length]-3, 3)];
        [query insertString:[NSString stringWithFormat:@" order by %@ DESC",orderKey] atIndex:[query length]];
    }
    FMResultSet *resultSet = [_db executeQuery:query];
    while ([resultSet next])
    {
        [msgArray addObject:[resultSet resultDictionary]];
    }
    return msgArray;
}

@end
