//
//  NLPullRefreshView.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/16.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "UIColor+Hex.h"

@protocol  NLRefreshableViewDelegate;
typedef enum{
    PullRefreshModeNone,
    PullDownToRefresh   = 1,
    PullUpToLoadMore    = 1<<1
}PullRefreshMode;

@interface NLPullRefreshTableView : UIView
@property (assign, nonatomic) PullRefreshMode               *refreshMode;
@property (assign, nonatomic) id<NLRefreshableViewDelegate> delegate;
@property (assign, nonatomic) id<UITableViewDataSource> dataSource;

- (void)stopLoad;
- (void)addRefreshTarget:(id)target action:(SEL)action;
@end


@protocol NLRefreshableViewDelegate<NSObject, UITableViewDelegate>

@optional
- (BOOL)pullRefreshViewShouldPullDown:(NLPullRefreshTableView *)pullRefreshView;
- (void)pullRefreshViewDidPullDown:(NLPullRefreshTableView *)pullRefreshView;
- (BOOL)pullRefreshViewShouldPullUp:(NLPullRefreshTableView *)pullRefreshView;
- (void)pullRefreshViewDidPullUp:(NLPullRefreshTableView *)pullRefreshView;
@end