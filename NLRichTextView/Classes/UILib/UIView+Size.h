//
//  UIView+Size.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/16.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Size)
// 返回宽度
@property (nonatomic, assign) CGFloat width;
// 返回高度
@property (nonatomic, assign) CGFloat height;
// 返回x坐标
@property (nonatomic, assign) CGFloat x;
// 返回y坐标
@property (nonatomic, assign) CGFloat y;
// 返回中心点x坐标
@property (nonatomic, assign) CGFloat centerX;
// 返回中心点y坐标
@property (nonatomic, assign) CGFloat centerY;

// 设置右边框的位置
@property (nonatomic, assign) CGFloat rightBorder;
// 设置下边框的位置
@property (nonatomic, assign) CGFloat bottomBorder;
@end
