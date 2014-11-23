//
//  NLHorizontalTableView.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/18.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "NLHorizontalTableView.h"

@implementation NLHorizontalTableView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = frame.size;
    }
    return self;
}

- (void)layoutSubviews{
    
}
@end
