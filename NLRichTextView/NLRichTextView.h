//
//  NLRichTextView.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/12.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkupParser.h"

typedef enum {
    NLTextAlignmentTop = 1,
    NLTextAlignmentMiddle,
    NLTextAlignmentBottom,
    
    NLTextAlignmentLeft = 1 << 4,
    NLTextAlignmentCenter,
    NLTextAlignmentRight
}NLTextAlignment;

@interface NLRichTextView : UIView{
@private
id      _ctFrame;
NSAttributedString      *_attString;
NSString                *_text;
}
/**
 *  must start with '<text>' and end with '</text>'
 *  <text><b color='0x000000' size='12' font-name='Optim' font-style='underline/strike' background-color='0x000000'></b><i></i><img></img></text>
 */
@property (assign, nonatomic) NLTextAlignment       alignment;
@property (strong, nonatomic) NSString              *richText;
@property (strong, readonly, nonatomic) NSString    *realText;
- (void)refresh;
@end
