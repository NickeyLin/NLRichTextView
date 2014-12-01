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
#import "NLAnimation.h"


@interface CircleDraw : UIView{
    CGFloat _drawAngle;
}
@property (assign, nonatomic) NSInteger angle;
@end
@implementation CircleDraw

- (id)initWithFrame:(CGRect)frame{
    CGFloat min = MIN(frame.size.width, frame.size.height);
    frame.size.width = min;
    frame.size.height = min;
    return [super initWithFrame:frame];
}
- (id)initWithWidth:(CGFloat)width{
    return [self initWithFrame:CGRectMake(0, 0, width, width)];
}

- (void)showLoadingAnimation{
    CABasicAnimation *animation = [NLAnimation scale:@(1.2) orgin:@(1) durTimes:0.25 Rep:100];
    [self.layer addAnimation:animation forKey:@"scale"];
}

- (void)removeAnimation{
    [self.layer removeAllAnimations];
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

    
    UIColor *aColor = [UIColor colorFromHex:0xc0c0c0];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //以10为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, self.width / 2, self.height / 2);
    CGContextAddArc(context, self.width / 2, self.height / 2, self.width / 2,  _drawAngle, -M_PI_2, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
}

@end
@interface RefreshHeaderView (){
    CircleDraw *_circleView;
    UILabel     *_lable;
}

@end
@implementation RefreshHeaderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _circleView = [[CircleDraw alloc]initWithWidth:2 * [self radius]];
        _circleView.center = [self centerPointOfCircle];
        [self addSubview:_circleView];
        
        _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
        _lable.centerX = self.width / 2;
        _lable.centerY = _circleView.bottomBorder + 10;
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.font = [UIFont systemFontOfSize:12];
        _lable.textColor = [UIColor colorFromHex:0xd0d0d0];
        [self addSubview:_lable];
    }
    return self;
}

- (void)layoutSubviews{
}
- (CGPoint)centerPointOfCircle{
    return CGPointMake(self.width / 2, 20);
}

- (CGFloat)radius{
    return 10;
}

- (void)hideContent:(BOOL)flag{
    _circleView.hidden = flag;
    _lable.hidden = flag;
}
#pragma mark - setter && getter
- (void)setAngle:(NSInteger)angle{
    _circleView.angle = angle;
    [self setNeedsDisplay];
}
- (NSInteger)angle{
    return _circleView.angle;
}

- (void)setStatus:(LoadingStatus)status{
    _status = status;
    if (LoadingStatusLoading == _status) {
        [_circleView showLoadingAnimation];
    }else{
        [_circleView removeAnimation];
    }
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
    
    switch (_status) {
        case LoadingStatusReady:{
            if (self.angle < 360) {
                _lable.text = @"下拉可以刷新";
            }else{
                _lable.text = @"松开立即刷新";
            }
            break;
        }
        case LoadingStatusLoading:{
            _lable.text = @"加载中...";
            break;
        }
        case LoadingStatusFinish:
        case LoadingStatusCancel:{
            break;
        }
        default:
            break;
    }
    
}
@end
