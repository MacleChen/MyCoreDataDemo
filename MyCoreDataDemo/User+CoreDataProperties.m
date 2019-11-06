//
//  User+CoreDataProperties.m
//  
//
//  Created by 陈帆 on 2019/11/6.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic age;
@dynamic createTime;
@dynamic income;
@dynamic isMan;
@dynamic userId;
@dynamic username;
@dynamic userIcon;

@end
