//
//  NLHorizontalTableView.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/18.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NLHorizontalTableView;

@protocol NLHorizontalTableViewDelegate <NSObject, UIScrollViewDelegate>

@required
- (NSInteger)numberOfCellsInHorizontalTableView:(NLHorizontalTableView *)tableView ;
- (UIView *)tableView:(NLHorizontalTableView *)tableView viewForCellInIndex:(NSInteger)index;

@optional

@end

@interface NLHorizontalTableView : UIScrollView
@property (assign, nonatomic) id<NLHorizontalTableViewDelegate> delegate;
@property (strong, nonatomic) UITableView *table;
- (id)initWithFrame:(CGRect)frame;

@end

