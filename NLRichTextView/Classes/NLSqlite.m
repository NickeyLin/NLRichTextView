//
//  CWorldAccountDB.m
//  CWorldHall
//
//  Created by 林建 on 12-11-12.
//  Copyright (c) 2012年 Nick. All rights reserved.
//

#ifndef DDLogInfo
#define DDLogInfo NSLog
#endif
#ifndef DDLogError
#define DDLogError NSLog
#endif

#import "NLSqlite.h"

@implementation NLSqlite

+ (NLSqlite *)currentDatabaseName{
    static NLSqlite *mySqlite;
    
    @synchronized(self)
    {
        if (!mySqlite)
            mySqlite = [[NLSqlite alloc] init];

        return mySqlite;
    }
}

+ (sqlite3 *)openDatabaseByName:(NSString *)name atPath:(NSString *)path{
    sqlite3 *database; 
    if (sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
        NSLog(@"打开数据库出现意外错误");
        return nil;
    }
    [self currentDatabaseName].path = path;
    [self currentDatabaseName].databaseName = name;
    return database;
}

+ (sqlite3 *)openDatabaseByName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:name];
    sqlite3 *database;
    if (sqlite3_open([dataFilePath UTF8String], &database) != SQLITE_OK) {
        NSLog(@"打开数据库出现意外错误！");
        return nil;
    }
    [self currentDatabaseName].path = dataFilePath;
    [self currentDatabaseName].databaseName = name;
    return database;
}


+ (BOOL)insertOrReplaceIntoDatabaseBySQL:(NSString *)sql{
    BOOL success = NO;
    sqlite3 *database = [self openDatabaseByName:[self currentDatabaseName].databaseName atPath:[self currentDatabaseName].path];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK)
    {
        
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            DDLogInfo(@"成功插入数据!--%@", [self currentDatabaseName].databaseName);
            success = YES;
        }else{
            DDLogError(@"%s\n%@",sqlite3_errmsg(database), sql);
        }
        sqlite3_finalize(statement);
    }else{
        DDLogError(@"%s",sqlite3_errmsg(database));
    }
    sqlite3_close(database);
    return success;
}


+ (BOOL)deleteFromDatabaseBySQL:(NSString *)sql{
    BOOL success = NO;
    sqlite3 *database = [self openDatabaseByName:[self currentDatabaseName].databaseName atPath:[self currentDatabaseName].path];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            DDLogInfo(@"成功删除数据!--%@", [self currentDatabaseName].databaseName);
            success = YES;
        }
        sqlite3_finalize(statement);
    }else{
        DDLogError(@"%s",sqlite3_errmsg(database));
    }
    sqlite3_close(database);
    return success;
}


+ (BOOL)selectFromDatabaseBySQL:(NSString *)sql{
    BOOL success = NO;
    sqlite3 *database = [self openDatabaseByName:[self currentDatabaseName].databaseName atPath:[self currentDatabaseName].path];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_ROW)
        {
            DDLogInfo(@"成功查找数据!--%@", [self currentDatabaseName].databaseName);
            success = YES;
        }else{
            DDLogError(@"%s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }else{
        DDLogError(@"%s",sqlite3_errmsg(database));
    }
    sqlite3_close(database);
    return success;
}


+ (BOOL)createTableIfNotExistsToDatabaseBySQL:(NSString *)sql{
    char *errorMsg;
    sqlite3 *database = [self openDatabaseByName:[self currentDatabaseName].databaseName atPath:[self currentDatabaseName].path];
    if (sqlite3_exec(database, [sql UTF8String], nil, nil, &errorMsg)) {
        DDLogError(@"%s",errorMsg);
        sqlite3_close(database);
        return NO;
    }
    return YES;
}


+ (BOOL)updateDatabaseBySQL:(NSString *)sql{
    BOOL success = NO;
    sqlite3 *database = [self openDatabaseByName:[self currentDatabaseName].databaseName atPath:[self currentDatabaseName].path];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            success = YES;
        }
        sqlite3_finalize(statement);
    }else{
        DDLogError(@"%s",sqlite3_errmsg(database));
    }
    sqlite3_close(database);
    return success;
}


+ (NSMutableArray *)resultOfSelectedFromDatabaseBySQL:(NSString *)sql{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *database = [self openDatabaseByName:[self currentDatabaseName].databaseName atPath:[self currentDatabaseName].path];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [result addObject:[[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding]];
        }
        sqlite3_finalize(statement);
    }else{
        DDLogError(@"%s",sqlite3_errmsg(database));
    }
    sqlite3_close(database);
    return result;
}


+ (NSMutableArray *)tableOfSelectedFromDatabaseBySQL:(NSString *)sql{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *database = [self openDatabaseByName:[self currentDatabaseName].databaseName atPath:[self currentDatabaseName].path];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *key = nil;
            NSString *value = nil;
            for (int i = 0; i < sqlite3_column_count(statement); i++) {
                key = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                if (SQLITE_INTEGER == sqlite3_column_type(statement, i)) {
                    value = [NSString stringWithFormat:@"%lld", sqlite3_column_int64(statement, i)];
                }else{
                    value = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding];
                }
                [dic setValue:value forKey:key];
            }
            [result addObject:dic];
        }
        sqlite3_finalize(statement);
    }else{
        DDLogError(@"%s",sqlite3_errmsg(database));
    }
    sqlite3_close(database);
//    NSLog(@"%@", result);
    return result;
}

@end
