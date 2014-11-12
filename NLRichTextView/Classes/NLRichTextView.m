//
//  NLRichTextView.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/12.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "NLRichTextView.h"
#import <CoreText/CoreText.h>

static inline BOOL validateTag(NSString *tag){
    return [tag isEqualToString:@"b"] || [tag isEqualToString:@"i"] || [tag isEqualToString:@"text"] || [tag isEqualToString:@"img"] || [tag isEqualToString:@"font"];
}

static UIColor *colorFromHex(long hex){
    int32_t r = (int32_t)((hex & 0xff0000) >> 16);
    int32_t g = (int32_t)((hex & 0x00ff00) >> 8);
    int32_t b = (int32_t)(hex & 0x0000ff);
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1];
}

@interface MarkupParser ()<NSXMLParserDelegate>
@property (strong, nonatomic) NSMutableArray    *arrayAttributeString;
@property (strong, nonatomic) NSString          *currentTag;
@property (strong, nonatomic) NSDictionary      *currentAttribute;
@property (strong, nonatomic) void              (^parserComplete)(NSAttributedString *attrString);
@end
@implementation MarkupParser

- (id)init{
    self = [super init];
    if (self) {
        _font = @"Optima";
        _images = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc{
    _font = nil;
    _images = nil;
}

- (void)markupXMLString:(NSString *)xmlString complete:(void (^)(NSAttributedString *attrString))completion{
    _parserComplete = completion;
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    parser.delegate = self;
    BOOL success = [parser parse];
    if (!success) {
        NSLog(@"error:%@", [parser parserError]);
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    _arrayAttributeString = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    _currentTag = elementName;
    _currentAttribute = attributeDict;
    NSLog(@"\nelementName:%@\nnamespace:%@\nqualifiedName:%@\nattributes:%@", elementName, namespaceURI, qName, attributeDict);
}

- (NSDictionary *)attributesWithTag:(NSString *)tag attrDict:(NSDictionary *)attrDict{
    NSString *currentFont = [attrDict objectForKey:@"font"];
    CGFloat currentFontSize = [[attrDict objectForKey:@"size"] floatValue];
    if (!currentFont || currentFont.length <= 0) {
        currentFont = _font;
    }
    if (currentFontSize <= 5) {
        currentFontSize = 16;
    }
    CTFontRef fontRef;
    UIColor *color = nil;
    
    if (validateTag(tag) && [tag.lowercaseString isEqualToString:@"b"]) {
        fontRef = CTFontCreateWithName((__bridge CFStringRef)[currentFont stringByAppendingString:@"-Bold"], currentFontSize, NULL);
    }else if (validateTag(tag) && [tag.lowercaseString isEqualToString:@"i"]) {
        fontRef = CTFontCreateWithName((__bridge CFStringRef)[currentFont stringByAppendingString:@"-Italic"], currentFontSize, NULL);
    }else{
        fontRef = CTFontCreateWithName((__bridge CFStringRef)[currentFont stringByAppendingString:@"-Regular"], currentFontSize, NULL);
    }
    NSString *colorHex = [attrDict objectForKey:@"color"];
    if (colorHex && colorHex.length > 0) {
        unsigned long long result;
        NSScanner *scanner = [NSScanner scannerWithString:colorHex];
        [scanner setScanLocation:2]; // bypass '0x' character
        [scanner scanHexLongLong:&result];
        color = colorFromHex(result);
    }else{
        color = [UIColor blackColor];
    }
    
    FontStyle fontStyle = FontStyleRegular;
    NSString *fontStyleString = [attrDict objectForKey:@"font-style"];
    if (fontStyleString && fontStyleString.length > 0) {
        if ([fontStyleString rangeOfString:@"underline"].location != NSNotFound) {
            fontStyle |= FontStyleUnderline;
        }
    }
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         (id)color.CGColor, kCTForegroundColorAttributeName,
                         (__bridge id)fontRef, kCTFontAttributeName,
                         @(fontStyle & FontStyleUnderline), kCTUnderlineStyleAttributeName,
                         nil];
    return dic;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:string attributes:[self attributesWithTag:_currentTag attrDict:_currentAttribute]];
    [_arrayAttributeString addObject:attrString];
    NSLog(@"foundCharacters:%@", string);
}
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    NSString *str = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    NSLog(@"foundCDATA:%@", str);
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSMutableAttributedString *attrstring = [[NSMutableAttributedString alloc]init];
    for (NSAttributedString *str in _arrayAttributeString) {
        [attrstring appendAttributedString:str];
    }
    if (_parserComplete) {
        _parserComplete(attrstring);
    }
}
@end

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
