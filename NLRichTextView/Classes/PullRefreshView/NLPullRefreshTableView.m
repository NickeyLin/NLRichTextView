//
//  NLPullRefreshView.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/16.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "NLPullRefreshTableView.h"
#import "RefreshHeaderView.h"
#import "UIView+Size.h"

#define OffsetY         -60
#define LoadingTimeout  30



@interface NLPullRefreshTableView ()<UITableViewDelegate>{
    UITableView         *_tableView;
    RefreshHeaderView   *_refreshHeaderView;
    UIView              *_viewFooter;
    BOOL                _loading;
    LoadingStatus       _loadingStatus;
    id                  _refreshTarget;
    SEL                 _refreshAction;
}
@property (assign, nonatomic) LoadingStatus loadingStatus;
@end
@implementation NLPullRefreshTableView
- (id)init{
    return [self initWithFrame:CGRectZero];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        _refreshHeaderView = [[RefreshHeaderView alloc]initWithFrame:self.bounds];
        _tableView.backgroundView = _refreshHeaderView;
    }
    return self;
}

- (void)awakeFromNib{
    [self addSubview:_refreshHeaderView];
    
    _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    _refreshHeaderView = [[RefreshHeaderView alloc]initWithFrame:self.bounds];
    _tableView.backgroundView = _refreshHeaderView;
    _tableView.backgroundColor = [UIColor whiteColor];
}
- (void)layoutSubviews{
}
- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _delegate = nil;
    _dataSource = nil;
    _refreshTarget = nil;
    _refreshAction = nil;
}

#pragma mark - Getter && Setter
- (void)setDataSource:(id<UITableViewDataSource>)dataSource{
    _dataSource = dataSource;
    _tableView.dataSource = _dataSource;
}
- (void)setLoadingStatus:(LoadingStatus)loadingStatus{
    _loadingStatus = loadingStatus;
    _refreshHeaderView.status = _loadingStatus;
}
#pragma mark - Methods
- (BOOL)validDelegateBySelector:(SEL)selector{
    return (_delegate && [_delegate respondsToSelector:selector]);
}
- (BOOL)shouldPullDown{
    if ([self validDelegateBySelector:@selector(pullRefreshViewShouldPullDown:)]) {
        return [_delegate pullRefreshViewShouldPullDown:self];
    }else{
        return NO;
    }
}
- (void)addRefreshTarget:(id)target action:(SEL)action{
    _refreshTarget = target;
    _refreshAction = action;
}

#pragma mark - Loading
- (void)startLoad{
    _loading = YES;
    self.loadingStatus = LoadingStatusLoading;
    
    [UIView animateWithDuration:.5 animations:^{
        _tableView.contentInset = UIEdgeInsetsMake(abs(OffsetY), 0, 0, 0);
    }completion:^(BOOL finished) {
        if (_refreshTarget && [_refreshTarget respondsToSelector:_refreshAction]) {
            [_refreshTarget performSelector:_refreshAction withObject:nil];
        }
    }];
}
- (void)stopLoad{
    _loading = NO;
    self.loadingStatus = LoadingStatusFinish;

    [UIView animateWithDuration:.25 animations:^{
        _tableView.contentInset = UIEdgeInsetsZero;
    }completion:^(BOOL finished) {
        self.loadingStatus = LoadingStatusReady;
        [_tableView reloadData];
    }];
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _refreshHeaderView.angle = -(scrollView.contentOffset.y) * 9 - 150;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [_delegate scrollViewDidZoom:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_delegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [_delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        if (_refreshHeaderView.angle >= 360) {
            if ([self shouldPullDown]) {
                [self startLoad];
            }
        }
    }
    
    if ([self validDelegateBySelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([self validDelegateBySelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [_delegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self validDelegateBySelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_delegate scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([self validDelegateBySelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [_delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if ([self validDelegateBySelector:@selector(viewForZoomingInScrollView:)]) {
        return [_delegate viewForZoomingInScrollView:scrollView];
    }else{
        return nil;
    }
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self validDelegateBySelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [_delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if ([self validDelegateBySelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [_delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self validDelegateBySelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [_delegate scrollViewShouldScrollToTop:scrollView];
    }else{
        return YES;
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if ([self validDelegateBySelector:@selector(scrollViewDidScrollToTop:)]) {
        return [_delegate scrollViewDidScrollToTop:scrollView];
    }
}

#pragma mark - UITableVieDelegate
// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [_delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [_delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [_delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [_delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        [_delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [_delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 44.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [_delegate tableView:tableView heightForHeaderInSection:section];
    }else{
        return 0.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [_delegate tableView:tableView heightForFooterInSection:section];
    }else{
        return 0.0f;
    }
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }else{
        return 44.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)]) {
        return [_delegate tableView:tableView estimatedHeightForHeaderInSection:section];
    }else{
        return 0.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0){
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)]) {
        return [_delegate tableView:tableView estimatedHeightForFooterInSection:section];
    }else{
        return 0.0f;
    }
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [_delegate tableView:tableView viewForHeaderInSection:section];
    }else{
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [_delegate tableView:tableView viewForFooterInSection:section];
    }else{
        return nil;
    }
}

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
        [_delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
        return [_delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }else{
        return YES;
    }
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]) {
        [_delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]) {
        [_delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        return [_delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }else{
        return indexPath;
    }
}
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        return [_delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }else{
        return indexPath;
    }
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [_delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }else{
        return nil;
    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }else{
        return nil;
    }
}// supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        return [_delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }else{
        return NO;
    }
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        [_delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        [_delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [_delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }else{
        return nil;
    }
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }else{
        return 0;
    }
}// return 'depth' of row for hierarchies

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }else{
        return NO;
    }
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
        return  [_delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }else{
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        [_delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}
@end
