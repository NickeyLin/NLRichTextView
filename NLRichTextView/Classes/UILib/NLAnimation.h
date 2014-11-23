//
//  CWorldAnimation.h
//  CWorldHall_iOS
//
//  Created by 林 建 on 13-4-2.
//  Copyright (c) 2013年 ChangHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface NLAnimation : NSObject
+(CABasicAnimation *)opacityFadeIn_Animation:(float)time;
+(CABasicAnimation *)opacityFadeOut_Animation:(float)time;
+(CABasicAnimation *)opacityForever_Animation:(float)time;
+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time;
+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x;
+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y;
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes;
+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes;
+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes;
+(CABasicAnimation *)movepoint:(CGPoint )point;
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount;
@end
