//
//  CWorldAccountDB.h
//  CWorldHall
//
//  Created by 林建 on 12-11-12.
//  Copyright (c) 2012年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface NLSqlite : NSObject
@property (strong, nonatomic) NSString  *path;
@property (strong, nonatomic) NSString  *databaseName;

+(NLSqlite *)currentDatabaseName;

/**
 根据名字打开数据库，若数据库文件不存在，则创建改名字的数据库。
 @param name 数据库名
 @return 返回打开的数据库
 */
+ (sqlite3 *)openDatabaseByName:(NSString *)name;

/**
 根据名字打开数据库，若数据库文件不存在，则创建改名字的数据库。
 @param name 数据库名
 @param path 数据库文件路径
 @return 返回打开的数据库
 */
+ (sqlite3 *)openDatabaseByName:(NSString *)name atPath:(NSString *)path;

/**
 通过SQL语句插入数据库，若key已存在，则替换（e."INSERT OR REPLACE INTO...")。
 @param sql SQL语句
 @return YES插入成功
 */
+ (BOOL)insertOrReplaceIntoDatabaseBySQL:(NSString *)sql;

/**
 通过SQL语句删除。
 @param sql SQL语句
 @return YES，删除成功
 */
+ (BOOL)deleteFromDatabaseBySQL:(NSString *)sql;

/**
 通过SQL语句查询
 @param sql SQL语句
 @return YES，成功查询数据（即表中存在要查询的数据）。
 */
+ (BOOL)selectFromDatabaseBySQL:(NSString *)sql;

/**
 通过SQL语句创建表。
 @param sql SQL语句
 @return YES，创建成功。
 */
+ (BOOL)createTableIfNotExistsToDatabaseBySQL:(NSString *)sql;

/**
 通过SQL语句更新表。
 @param sql SQL语句
 @return YES，更新成功。
 */
+ (BOOL)updateDatabaseBySQL:(NSString *)sql;

/**
 通过SQL语句查询表中某一列，并以数组返回查询结果。
 @param sql SQL语句
 @return 结果数组
 */
+ (NSMutableArray *)resultOfSelectedFromDatabaseBySQL:(NSString *)sql;

/**
 通过SQL语句查询表中多列，并以数组返回查询结果。数组中每个元素以字典形式存放数据表中一行数据。
 @param sql SQL语句
 @return 结果
 */
+ (NSMutableArray *)tableOfSelectedFromDatabaseBySQL:(NSString *)sql;
@end
