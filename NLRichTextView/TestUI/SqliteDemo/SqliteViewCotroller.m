//
//  SqliteViewCotroller.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/15.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "SqliteViewCotroller.h"
#import "NLSqlite.h"
#import "RATreeView.h"
#import "ContactInfoData.h"

#define URLDemo @"http://10.3.30.80:10080/mei/company/struct"
@interface SqliteViewCotroller()<RATreeViewDataSource, RATreeViewDelegate>
@property (strong, nonatomic) IBOutlet RATreeView *treeView;
@property (strong, nonatomic) NSArray   *arrayList;
@end

@implementation SqliteViewCotroller

- (void)viewDidLoad{
    [super viewDidLoad];
    [NLSqlite openDatabaseByName:@"contact.sqlite" atPath:[[NSBundle mainBundle]pathForResource:@"contact" ofType:@"sqlite"]];
    NSMutableArray *array = [NLSqlite tableOfSelectedFromDatabaseBySQL:@"select * from t_group where parentid=0"];
    _arrayList = [NSArray array];
    for (NSDictionary *dic in array) {
        ContactInfoData *contactInfo = [[ContactInfoData alloc]initWithJSON:dic];
        contactInfo.level = 0;
        _arrayList = [_arrayList arrayByAddingObject:contactInfo];
    }
    _treeView.delegate = self;
    _treeView.dataSource = self;
    NSLog(@"%@", array);
}

#pragma mark - RATreeViewDataSource
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item{
    static NSString *identifier = @"TreeCell";
    UITableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    switch (((ContactInfoData *)item).level) {
        case 0:{
            cell.backgroundColor = [UIColor colorWithRed:0 green:.9 blue:.1 alpha:1];
            break;
        }
        case 1:{
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:1 blue:0 alpha:1];
            break;
        }
        case 2:{
            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
            break;
        }
        case 3:{
            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
            break;
        }
        case 4:{
            
        }
        default:
            break;
    }
    
    NSString *title = @"";
    if (((ContactInfoData *)item).level > 0) {
        for (int i = 0; i < ((ContactInfoData *)item).level; i++) {
            if (i == ((ContactInfoData *)item).level - 1) {
                title = [title stringByAppendingString:@"|--->"];
            }else{
                title = [title stringByAppendingString:@"\t"];
            }
        }
    }
    
    cell.textLabel.text = [title stringByAppendingString:((ContactInfoData *)item).name];
    return cell;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item{
    if (!item) {
        return _arrayList[index];
    }else{
        return ((ContactInfoData *)item).children[index];
    }
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item{
    if (!item) {
        return _arrayList.count;
    }else{
        return ((ContactInfoData *)item).children.count;
    }
}

#pragma mark - RATreeViewDelegate
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item{
    if (((ContactInfoData *)item).children.count > 0) {
        return;
    }
    NSArray *arrayResult = [NLSqlite tableOfSelectedFromDatabaseBySQL:[NSString stringWithFormat:@"select * from t_group where parentid=%@", ((ContactInfoData *)item).group_id]];
    NSArray *arrayTemp = [NSArray array];
    for (NSDictionary *dic in arrayResult) {
        ContactInfoData *obj = [[ContactInfoData alloc]initWithJSON:dic];
        obj.level = ((ContactInfoData *)item).level + 1;
        arrayTemp = [arrayTemp arrayByAddingObject:obj];
    }
    ((ContactInfoData *)item).children = arrayTemp;
}
@end
