//
//  UIColor+Hex.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/12/4.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *)colorFromHex:(unsigned long)hex;

/**
 *  通过16进制字符串创建UIColor，字符串必须以"0x"或者"#"开始，否者返回nil。如果字符串是以"0x"或者"#"开始，但并不是一个有效的16进制，将会返回[UIColor blackColor]。
 *
 *  @param hexString 代表颜色的十六进制字符串
 *
 *  @return UIColor 实例
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end
