//
//  CoreDataStack.m
//  MyCoreDataDemo
//
//  Created by 陈帆 on 2019/11/6.
//  Copyright © 2019 陈帆. All rights reserved.
//

#import "CoreDataStack.h"
#import "User+CoreDataClass.h"

#define tableName @"User"

@interface CoreDataStack()

/// 文件目录
@property(nonatomic, copy) NSString *documentDir;

/// 上下文
@property(nonatomic, retain) NSManagedObjectContext *context;

@property(nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, copy) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataStack

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;


/// 单例
+ (instancetype)shareInstance {
    static CoreDataStack *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance =[[CoreDataStack alloc] init];
    });
    
    return instance;
}



- (NSPersistentCloudKitContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentCloudKitContainer alloc] initWithName:@"MyCoreDataDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (NSString *)documentDir {
    if (!_documentDir) {
        _documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    return _documentDir;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
//        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context = self.persistentContainer.viewContext;
    }
    
    return _context;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"coreData" withExtension:@"momd"]];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        NSString *sqliteURL = [_documentDir stringByAppendingPathComponent:@"coreData.sqlite"];
        NSDictionary *options = @{
            NSMigratePersistentStoresAutomaticallyOption : @YES,
            NSInferMappingModelAutomaticallyOption : @YES
        };
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        @try {
            [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqliteURL] options:options error:nil];
        } @catch (NSException *exception) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            NSError *wrappedError = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:6666 userInfo:dict];
            NSLog(@"Unresolved error %@, %@", wrappedError, wrappedError.userInfo);
            abort();
        } @finally {
        }
    }
    
    return _persistentStoreCoordinator;
}


- (User *)newUserEntity {
    return [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:self.context];
}

/// 增加用户实体
/// @param user 用户对象
- (void)addUser:(User *)user {
    [self saveContext];
}


/// 获取用户列表
- (NSArray<User *> *)getUserList {
    @try {
        NSArray *userList = [self.context executeFetchRequest:[User fetchRequest] error:nil];
        return userList;
    } @catch (NSException *exception) {
        NSLog(@"getUserList error:%@", exception.description);
    }
}

/// 删除指定索引用户
/// @param index 索引值
- (void)deleteUser:(NSUInteger)index {
    @try {
        NSArray *userList = [self.context executeFetchRequest:[User fetchRequest] error:nil];
        if (userList.count > 0 && index < userList.count) {
            [self.context deleteObject:userList[0]];
            [[CoreDataStack shareInstance] saveContext];
        } else {
             NSLog(@"deleteUser failed. reason:data is null or index larger array count");
        }
    } @catch (NSException *exception) {
        NSLog(@"deleteUser error. %@", exception.description);
    }
}

/// 删除所有用户
- (void)deleteAllUser {
    @try {
        NSArray *userList = [self.context executeFetchRequest:[User fetchRequest] error:nil];
        if (userList.count > 0) {
            [self.context deletedObjects];
            [[CoreDataStack shareInstance] saveContext];
        } else {
             NSLog(@"deleteUser failed. reason:data is null");
        }
    } @catch (NSException *exception) {
        NSLog(@"deleteUser error. %@", exception.description);
    }
}

/// 更新（修改）用户
/// @param user 用户对象
- (void)updateUser:(User *)user {
    @try {
        NSArray *userList = [self.context executeFetchRequest:[User fetchRequest] error:nil];
        for (User *tempUser in userList) {
            if ([tempUser.userId isEqual:user.userId]) {
                tempUser.username = user.username;
                tempUser.age = user.age;
                tempUser.isMan = user.isMan;
                break;
            }
        }
        [[CoreDataStack shareInstance] saveContext];
    } @catch (NSException *exception) {
        NSLog(@"deleteUser error. %@", exception.description);
    }
}

@end
