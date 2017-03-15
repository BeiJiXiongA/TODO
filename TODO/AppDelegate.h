//
//  AppDelegate.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/7.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OperationDB.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) OperationDB *operationDB;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

