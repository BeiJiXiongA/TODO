//
//  OperationDB.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/11.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

#define To_Do_Table  @"todotable"
#define Done_Log_Tabel @"donelogtabel"

@interface OperationDB : NSObject
{
    FMDatabase *_db;
}

+(id)shareOperationDB;

-(BOOL)insertRecord:(NSDictionary *)dict andTableName:(NSString *)tableName;

-(BOOL)deleteRecordWithDict:(NSDictionary *)dict andTableName:(NSString *)tableName;
-(BOOL)updateKey:(NSString *)key toValue:(NSString *)value
    withParaDict:(NSDictionary *)dict
    andTableName:(NSString *)tableName;
-(NSMutableArray *)findSetWithKey:(NSString *)key
                         andValue:(NSString *)value
                     andTableName:(NSString *)tableName;

-(NSMutableArray *)findSetWithDictionary:(NSDictionary *)dict
                            andTableName:(NSString *)tableName;

-(NSMutableArray *)findSetWithDictionary:(NSDictionary *)dict
                             orderByName:(NSString *)orderKey
                            andTableName:(NSString *)tableName;

@end
