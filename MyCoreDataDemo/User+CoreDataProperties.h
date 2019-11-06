//
//  User+CoreDataProperties.h
//  
//
//  Created by 陈帆 on 2019/11/6.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSDecimalNumber *income;
@property (nonatomic) BOOL isMan;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *userIcon;

@end

NS_ASSUME_NONNULL_END
