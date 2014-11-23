//
//  RefreshHeaderView.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/22.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "RefreshHeaderView.h"
#import "UIView+Size.h"
#import "NLCustom.h"

@interface RefreshHeaderView (){
    CGFloat _drawAngle;
}

@end
@implementation RefreshHeaderView

- (CGPoint)centerPointOfCircle{
    return CGPointMake(self.width / 2, 20);
}

- (CGFloat)radius{
    return 10;
}

- (void)setAngle:(NSInteger)angle{
    _angle = angle;
    if (angle < 0) {
        _angle = 0;
    }else if (angle > 360){
        _angle = 360;
    }
    _drawAngle = (_angle - 90) / 180.0 * M_PI;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    CGContextSaveGState(context);
    
    //
    CGContextSetFillColorWithColor(context, [UIColor colorFromHex:0xfafafa].CGColor);//填充颜色
    CGContextFillRect(context, self.bounds);
    CGContextRestoreGState(context);

    UIColor *aColor = [UIColor colorFromHex:0xe4e4e4];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //以10为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, [self centerPointOfCircle].x, [self centerPointOfCircle].y);
    CGContextAddArc(context, [self centerPointOfCircle].x, [self centerPointOfCircle].y, [self radius],  _drawAngle, -M_PI_2, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    if (_angle < 360) {
        [@"下拉可以刷新" drawInRect:CGRectMake(100, [self centerPointOfCircle].y + 15, 120, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorFromHex:0xd0d0d0], NSParagraphStyleAttributeName:style}];
    }else{
        [@"松开立即刷新" drawInRect:CGRectMake(100, [self centerPointOfCircle].y + 15, 120, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorFromHex:0xd0d0d0], NSParagraphStyleAttributeName:style}];
    }
}
@end
