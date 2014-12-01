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
    return;
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=909187876"];//284417350 yz--909187876
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        if (connectionError || data == nil) {
            NSLog(@"%@", connectionError);
            error = [NSError errorWithDomain:@"CheckUpdate" code:201 userInfo:@{NSLocalizedDescriptionKey: @"未获取到版本信息，请稍后再试。"}];
            return;
        }
        NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            error = [NSError errorWithDomain:@"CheckUpdate" code:202 userInfo:@{NSLocalizedDescriptionKey: @"参数异常"}];
            
            return;
        }
        NSArray *results = [json valueForKey:@"results"];
        if (!results || results.count <= 0) {
            error = [NSError errorWithDomain:@"CheckUpdate" code:203 userInfo:@{NSLocalizedDescriptionKey: @"参数异常"}];
            
            return;
        }
        _dicData = results[0];
        [_pullRefreshView stopLoad];
    }];
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
