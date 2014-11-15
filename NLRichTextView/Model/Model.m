//
//  Model.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/15.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "Model.h"

@implementation Model
- (id)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        for (NSString *key in [json allKeys]) {
            NSString *value = [json valueForKey:key];
            NSString *keyPath = nil;
            if ([key isEqualToString:@"id"]) {
                keyPath = @"mId";
            }else{
                keyPath = key;
            }
            [self setValue:value forKeyPath:keyPath];
        }
    }
    return self;
}
@end
