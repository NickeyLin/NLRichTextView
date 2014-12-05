//
//  CWorldLoginNavigationController.h
//  CWorldHall_iOS
//
//  Created by Nick on 13-3-20.
//  Copyright (c) 2013年 ChangHong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NLNavigationController : UINavigationController<UINavigationControllerDelegate>

- (void)handlePan:(UIPanGestureRecognizer *)panGesture;
- (void)setPanGestureRecognizerEnable:(BOOL)enable;
@end
