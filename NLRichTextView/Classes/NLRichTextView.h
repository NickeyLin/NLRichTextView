//
//  NLRichTextView.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/12.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NLTextAlignmentTop = 1,
    NLTextAlignmentMiddle,
    NLTextAlignmentBottom,
    
    NLTextAlignmentLeft = 1 << 4,
    NLTextAlignmentCenter,
    NLTextAlignmentRight
}NLTextAlignment;

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

@interface MarkupParser : NSObject
@property (strong, nonatomic) NSMutableArray    *images;
/**
 *  解析xml字符串
 *
 *  @param xmlString  xml string
 *  @param completion 完成回调
 */
- (void)markupXMLString:(NSString *)xmlString complete:(void (^)(NSAttributedString *attrString))completion;
@end

@interface NLRichTextView : UIView{
@private
    id      _ctFrame;
    NSAttributedString      *_attString;
    NSString                *_text;
}

@property (assign, nonatomic) NLTextAlignment       alignment;

/**
 *  must start with '<text>' and end with '</text>'
 *  <text><b color='0x000000' size='12' font-name='Optim' font-style='underline/strike' background-color='0x000000'></b><i></i><img></img></text>暂不支持嵌套
 */
@property (strong, nonatomic) NSString              *richText;
@property (strong, readonly, nonatomic) NSString    *realText;
- (void)refresh;
@end
