//
//  PullRefreshViewController.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/16.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLPullRefreshTableView.h"

@interface PullRefreshViewController : UIViewController
@property (weak, nonatomic) IBOutlet NLPullRefreshTableView *pullRefreshView;

@end
