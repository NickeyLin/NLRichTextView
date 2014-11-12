//
//  MarkupParser.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/12.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "MarkupParser.h"
#import <CoreText/CoreText.h>
static void deallockCallback(void * ref){
    ref = nil;
}

static CGFloat widthCallback(void *ref){
    return [((NSString *)[(__bridge NSDictionary *)ref objectForKey:@"width"]) floatValue];
}

static CGFloat ascentCallback(void *ref){
    return [((NSString *)[(__bridge NSDictionary *)ref objectForKey:@"height"]) floatValue];
}

static CGFloat descentCallback(void *ref){
    return [((NSString *)[(__bridge NSDictionary *)ref objectForKey:@"descent"]) floatValue];
}
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
        _color = [UIColor blackColor];
        _strokeColor = [UIColor whiteColor];
        _strokeWidth = 0.0;
        _fontSize = 16;
        _images = [NSMutableArray array];
        _fontType = Regular;
    }
    return self;
}

- (void)dealloc{
    _font = nil;
    _color = nil;
    _strokeColor = nil;
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
        currentFontSize = _fontSize;
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
        color = _color;
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
