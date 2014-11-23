//
//  UIView+Size.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/16.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "UIView+Size.h"

static CGFloat roundToHalf(CGFloat length){
    NSInteger lengthTrim = (int) length;
    if ( length - lengthTrim < 0.5 ){
        return lengthTrim;
    }else if ( length - lengthTrim > 0.5 ){
        return lengthTrim + 1;
    }else{
        return lengthTrim + 0.5;
    }
}

@implementation UIView (Size)
- (CGFloat)width{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width{
    CGRect viewFrame = self.frame;
    viewFrame.size.width = width;
    self.frame = viewFrame;
}

- (CGFloat)height{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height{
    CGRect viewFrame = self.frame;
    viewFrame.size.height = height;
    self.frame = viewFrame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x{
    CGRect viewFrame = self.frame;
    viewFrame.origin.x = roundToHalf(x);
    
    self.frame = viewFrame;
}

- (CGFloat)centerX{
    CGRect viewFrame = self.frame;
    return viewFrame.origin.x + viewFrame.size.width / 2;
}

- (void)setCenterX:(CGFloat)centerX{
    CGRect viewFrame = self.frame;
    viewFrame.origin.x = roundToHalf(centerX - viewFrame.size.width / 2);
    
    self.frame = viewFrame;
}

- (CGFloat)centerY{
    CGRect viewFrame = self.frame;
    return viewFrame.origin.y + viewFrame.size.height / 2;
}

- (void)setCenterY:(CGFloat)centerY{
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = roundToHalf(centerY - viewFrame.size.height / 2);
    
    self.frame = viewFrame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y{
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = roundToHalf(y);
    
    self.frame = viewFrame;
}

- (CGFloat)rightBorder{
    CGRect viewFrame = self.frame;
    
    return viewFrame.origin.x + viewFrame.size.width;
}

- (void)setRightBorder:(CGFloat)rightBorder{
    CGRect viewFrame = self.frame;
    viewFrame.origin.x = rightBorder - viewFrame.size.width;
    
    self.frame = viewFrame;
}

- (CGFloat)bottomBorder{
    CGRect viewFrame = self.frame;
    
    return viewFrame.origin.y + viewFrame.size.height;
}

- (void)setBottomBorder:(CGFloat)bottomBorder{
    CGRect viewFrame = self.frame;
    viewFrame.origin.y = bottomBorder - viewFrame.size.height;
    
    self.frame = viewFrame;
}
@end
