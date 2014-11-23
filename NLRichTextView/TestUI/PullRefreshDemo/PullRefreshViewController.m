//
//  PullRefreshViewController.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/16.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "PullRefreshViewController.h"

@interface PullRefreshViewController ()<NLRefreshableViewDelegate, UITableViewDataSource>

@end
@implementation PullRefreshViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    _pullRefreshView.delegate = self;
    _pullRefreshView.dataSource = self;
}

- (BOOL)pullRefreshViewShouldPullDown:(NLPullRefreshTableView *)pullRefreshView{
    return YES;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CELL_Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSLog(@"%d", indexPath.row);
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

@end
