//
//  NLCustom.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/16.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "NLCustom.h"
@implementation UIColor (ColorFromHex)
+ (UIColor *)colorFromHex:(unsigned long)hex{
    int32_t r = (int32_t)((hex & 0xff0000) >> 16);
    int32_t g = (int32_t)((hex & 0x00ff00) >> 8);
    int32_t b = (int32_t)(hex & 0x0000ff);
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString{
    if (!hexString || (![hexString hasPrefix:@"0x"] && ![hexString hasPrefix:@"#"])) {
        return nil;
    }
    UIColor *color = nil;
    unsigned long long result;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ([hexString hasPrefix:@"0x"]) {
        [scanner scanHexLongLong:&result];
        color = [self colorFromHex:(unsigned long)result];
    }else if ([hexString hasPrefix:@"#"]){
        [scanner setScanLocation:1];
        [scanner scanHexLongLong:&result];
        color = [self colorFromHex:(unsigned long)result];
    }
    return color;
}

@end
@implementation NLCustom

@end
