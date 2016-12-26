//
//  DataBaseManage.m
//  SQLiteTest
//
//  Created by wapage-mac on 16/12/18.
//  Copyright © 2016年 wapage-mac. All rights reserved.
//

#import "DataBaseManage.h"

@implementation DataBaseManage

+ (sqlite3 *)sharedInstance {
    static sqlite3 * database = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"database" ofType:@"db"];
        if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
            NSLog(@"open database");
        } else{
            sqlite3_close(database); NSLog(@"error %s",sqlite3_errmsg(database));
        }
    });
    return database;
}

-(void)operateDatabase{
    const char * sql = "select name,regioninfo from people,region where people.region=region.regionid";
    sqlite3_stmt *statement; //创建sql语句对象
    int sqlResult = sqlite3_prepare_v2([DataBaseManage sharedInstance], sql, -1, &statement, NULL); //准备sql语句
    //是否准备结束
    if ( sqlResult== SQLITE_OK) {
        //开始遍历查询结果
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"name %s, region %s",sqlite3_column_text(statement, 0),sqlite3_column_text(statement, 1));
        }
    }
}

@end
