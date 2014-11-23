//
//  RefreshHeaderView.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/22.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    LoadingStatusReady,
    LoadingStatusLoading,
    LoadingStatusFinish,
    LoadingStatusCancel
}LoadingStatus;

@interface RefreshHeaderView : UIView
/**
 *  角度0-360
 */
@property (assign, nonatomic) NSInteger angle;

@property (assign, nonatomic) LoadingStatus status;
@end
