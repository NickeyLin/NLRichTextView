//
//  NLRichTextView.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/12.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "NLRichTextView.h"
#import <CoreText/CoreText.h>

@implementation NLRichTextView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)refresh{
    if (_attString) {
        [self setRichText:_text];
        [self setNeedsDisplay];
    }
}

- (void)setRichText:(NSString *)richText{
    _text = richText;
    MarkupParser *p = [[MarkupParser alloc]init];
    [p markupXMLString:richText complete:^(NSAttributedString *attrString) {
        _attString = attrString;
        int height = [self getAttributedStringHeightWithString:attrString WidthValue:self.bounds.size.width];
        height += 20;
        if (height >= self.frame.size.height) {
            height = self.frame.size.height;
        }
        
        CGRect textFrame;
        if (_alignment & NLTextAlignmentCenter) {
            textFrame = CGRectMake(0, (self.frame.size.height - height) / 2, self.frame.size.width, height);
        }else{
            textFrame = self.bounds;
        }
        CGMutablePathRef path = CGPathCreateMutable();
        textFrame = CGRectInset(textFrame, 10, 10);
        CGPathAddRect(path, NULL, textFrame );
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attString);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [_attString length]), path, NULL);
        _ctFrame = (__bridge id)(frame);
        CFRelease(framesetter);
        CFRelease(path);
    }];
}
- (int)getAttributedStringHeightWithString:(NSAttributedString *)string  WidthValue:(int) width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要<strong>计算</strong><strong>高度</strong>的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((__bridge CTFrameRef)(_ctFrame), context);
    CFRelease((__bridge CFTypeRef)(_ctFrame));
}

- (void)dealloc{
    
}
@end
