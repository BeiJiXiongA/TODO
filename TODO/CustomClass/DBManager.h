//
//  DBManager.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/8.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBManager : NSObject
{
    NSString *_name;
}
@property (nonatomic, readonly) FMDatabase *dataBase;

+(DBManager *) defaultDBManager;

- (void) close;

@end
