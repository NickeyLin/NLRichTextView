//
//  MarkupParser.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/12.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    Regular = 0,
    Bold = 1,
    Italic = 1 << 1,
    Underline = 1 << 2,
    Strikeout = 1 << 3
}FontType;

typedef enum{
    FontWeightRegular = 0,      //0
    FontWeightBold,             //1
    FontWeightItalic            //2
}FontWeight;

typedef enum {
    FontStyleRegular = 0,           //0x00
    FontStyleUnderline = 1,         //0x01
    FontStyleStrikeout = 1 << 1     //0x02
}FontStyle;
OBJC_EXTERN NSString *kNLRichTextAttributeFontType;
OBJC_EXTERN NSString *kNLRichTextAttributeFontSize;
OBJC_EXTERN NSString *kNLRichTextAttributeFontFamily;
OBJC_EXTERN NSString *kNLRichTextAttributeFontColor;
OBJC_EXTERN NSString *kNLRichTextAttributeFontBackgroundColor;



@interface MarkupParser : NSObject
@property (strong, nonatomic) NSString  *font;
@property (strong, nonatomic) UIColor   *color;
@property (strong, nonatomic) UIColor   *strokeColor;
@property (assign, nonatomic) CGFloat   strokeWidth;
@property (assign, nonatomic) CGFloat   fontSize;
@property (assign, nonatomic) FontType  fontType;
@property (strong, nonatomic) NSMutableArray    *images;
/**
 *  <b color='0x000000' size='12' font-name='Optim' font-style='underline/strike' background-color='0x000000'></b><i></i><img></img>
 *
 *  @param xmlString  xml string
 *  @param completion 完成回调
 */
- (void)markupXMLString:(NSString *)xmlString complete:(void (^)(NSAttributedString *attrString))completion;
@end
