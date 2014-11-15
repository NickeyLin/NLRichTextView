//
//  ContactInfoData.h
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/15.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "Model.h"

@interface ContactInfoData : Model
@property (strong, nonatomic) NSString  *mId;
@property (strong, nonatomic) NSString  *group_id;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *parentid;

@property (assign, nonatomic) NSInteger level;
/**
 *  NSArray<ContactInfoData>
 */
@property (strong, nonatomic) NSArray   *children;

@end
