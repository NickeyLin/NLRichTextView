//
//  PullRefreshViewController.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/16.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "PullRefreshViewController.h"

@interface PullRefreshViewController ()<NLRefreshableViewDelegate, UITableViewDataSource>{
    NSDictionary *_dicData;
}

@end
@implementation PullRefreshViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    _dicData = @{@"1":@"1",@"2":@"2"};
    _pullRefreshView.delegate = self;
    _pullRefreshView.dataSource = self;
    [_pullRefreshView addRefreshTarget:self action:@selector(actionRefresh)];
}

- (BOOL)pullRefreshViewShouldPullDown:(NLPullRefreshTableView *)pullRefreshView{
    return YES;
}
- (void)loadData{
    [_pullRefreshView performSelector:@selector(stopLoad) withObject:nil afterDelay:1];
}
- (void)actionRefresh{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1];
//    _arrayData = [_arrayData arrayByAddingObject:@"12"];
//    [_pullRefreshView performSelector:@selector(stopLoad) withObject:nil afterDelay:2];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dicData allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CELL_Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [[_dicData allKeys][indexPath.row] description];
    return cell;
}

@end
