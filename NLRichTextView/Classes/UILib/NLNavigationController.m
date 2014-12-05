//
//  CWorldRootNavigationController.m
//  CWorldHall_iOS
//
//  Created by Nick on 13-3-20.
//  Copyright (c) 2013年 ChangHong. All rights reserved.
//

#import "NLNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"

#define NavigationBarHeight 40
#define TagLoadingView      1000

//@interface UINavigationBar (CustomHeight)
//@end
//@implementation UINavigationBar (CustomHeight)
//
//- (CGSize)sizeThatFits:(CGSize)size{
//    CGSize newSize = CGSizeMake(self.frame.size.width, NavigationBarHeight);
//    return newSize;
//}
//@end

typedef enum{
    RootNavJumpNone = 0x0,
    RootNavJumpDefault = 0xf,
    RootNavJumpPop = 1 << 1,
    RootNavJumpDismiss = 1 << 2,
}RootNavJump;

@interface NLNavigationController ()<UIGestureRecognizerDelegate>{
    CGPoint     _initialPoint;
    BOOL        _isMoving;
    RootNavJump _rootNavJum;
    UIImageView *_ivShadow;
}
@property (strong, nonatomic) UIViewController  *willShow;

@property (strong, nonatomic) NSMutableArray            *screenShotsList;
@property (strong, nonatomic) UIPanGestureRecognizer    *pan;
@property (strong, nonatomic) UIView                    *backgroundView;
@property (strong, nonatomic) UIView                    *blackMask;
@property (strong, nonatomic) UIImageView               *lastScreenShotView;
@end

@implementation NLNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    _screenShotsList = [NSMutableArray array];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
//    [_leftMenuItem addTarget:self action:@selector(actionLeftMenuItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_pan delaysTouchesBegan];
    _pan.delegate = self;
    
    UINavigationBar *navBar = self.navigationBar;

    if ([navBar respondsToSelector:@selector(setBarTintColor:)]) {
        [navBar setBarTintColor:[UIColor colorFromHex:0xfdfdfd]];
    }else{
        [navBar setTintColor:[UIColor colorFromHex:0xfdfdfd]];
    }
    
    [self.view addGestureRecognizer:_pan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)actionLeftMenuItem:(id)sender{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeViewPropertyAfterAnimation" object:@"hideKeyboard"];
//    [[self slidingViewController] anchorTopViewToSide:CHRight];
//}

- (void)setRoundCornerOfNavgationBar:(UINavigationBar *)navBar{
    CALayer *navLayer = navBar.layer;
    [navLayer setShadowColor: [[UIColor blackColor] CGColor]];
    [navLayer setShadowOpacity:0.85f];
    [navLayer setShadowOffset: CGSizeMake(0.0f, 1.5f)];
    [navLayer setShadowRadius:2.0f];
    [navLayer setShouldRasterize:YES];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:navLayer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = navLayer.bounds;
    maskLayer.path = maskPath.CGPath;
    [navLayer addSublayer:maskLayer];
    navLayer.mask = maskLayer;
}
- (void)showShadow{
    
    if (!_ivShadow) {
        _ivShadow = [[UIImageView alloc]initWithFrame:CGRectMake(-20, 0, 20, self.view.frame.size.height)];
        _ivShadow.image = [UIImage imageNamed:@"cworld_slider_shadow"];
        [self.view addSubview:_ivShadow];
    }
    _ivShadow.hidden = NO;
}

- (void)dismissShadow{
    _ivShadow.hidden = YES;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    UIViewController *rootController = [navigationController.viewControllers objectAtIndex:0];
//    NSLog(@"%@", [[navigationController.viewControllers objectAtIndex:0] class]);
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    _willShow = viewController;
    
    //navigationBar Title 样式
    if (__IPHONE_7_0) {
        NSShadow *shadow = [[NSShadow alloc]init];
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowOffset = CGSizeMake(0, -1.0);
        viewController.navigationController.navigationBar.titleTextAttributes =  [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil,NSShadowAttributeName,[UIFont boldSystemFontOfSize:20.0],NSFontAttributeName, nil];
    }
    if ([viewController respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        viewController.automaticallyAdjustsScrollViewInsets = NO;
    }

    if ([navigationController.viewControllers count] == 0 ||[[navigationController.viewControllers objectAtIndex:0] class] == [viewController class]) {
        return;
    }
    
}

- (void)actionLeftButtonItem:(id)sender{
    [self popViewControllerAnimated:YES];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    if (_willShow && [_willShow respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [_willShow supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }
    if ([_willShow isKindOfClass:NSClassFromString(@"CWorldImagePlayerController")] ||
        [_willShow isKindOfClass:NSClassFromString(@"CWorldVideoPlayerController")]) {
        
        return YES;
    }
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}
//#endif

#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    CGPoint currentVelocity= [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:[UIApplication sharedApplication].keyWindow];
    if (currentVelocity.x < 0) {
        return YES;
    }else{
        return NO;
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"%@", [self.topViewController class]);
    [self.topViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self setRoundCornerOfNavgationBar:self.navigationBar];
    [_willShow didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
#pragma mark - pan-right to pop viewController
- (void)setPanGestureRecognizerEnable:(BOOL)enable{
    _pan.enabled = enable;
}
//override push && pop methods
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [_screenShotsList addObject:[self capture]];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [_screenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (UIImage *)capture{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)moveToX:(CGFloat)x{
    x = x <=0 ? 0 : x;
    x = x >= 320 ? 320 : x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.8 - (x / 400);
    
    CGPoint center = CGPointZero;
    center.y = _lastScreenShotView.center.y;
    center.x += x / 2;
    if (_rootNavJum & RootNavJumpPop) {
        _lastScreenShotView.center = center;
    }
    
    _blackMask.alpha = alpha;
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture{

    if (self.viewControllers.count <= 1 && !self.presentingViewController) {
        return;
    }
    BOOL shouldDismiss = self.viewControllers.count <= 1 && self.presentingViewController;
    
    CGPoint currentPoint = [panGesture locationInView:[UIApplication sharedApplication].keyWindow];
    CGPoint currentVelocity= [panGesture velocityInView:[UIApplication sharedApplication].keyWindow];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _initialPoint = currentPoint;
        if (_initialPoint.x > 100) {
            return;
        }
        _isMoving = YES;
        [self showShadow];
        if (!_backgroundView || _backgroundView.superview) {
            _backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
            [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
            
            _blackMask = [[UIView alloc]initWithFrame:_backgroundView.bounds];
            _blackMask.backgroundColor = [UIColor blackColor];
            [_backgroundView addSubview:_blackMask];
        }
        _backgroundView.hidden = NO;
        if (_lastScreenShotView) {
            [_lastScreenShotView removeFromSuperview];
            _lastScreenShotView = nil;
        }
        
        if (shouldDismiss) {
            
            [_lastScreenShotView addSubview:self.presentingViewController.view];
            [_backgroundView insertSubview:self.presentingViewController.view belowSubview:_blackMask];
            _rootNavJum = RootNavJumpDismiss;
        }else if (self.viewControllers.count > 1){
            UIImage *lastScreenShot = [_screenShotsList lastObject];
            _lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
            [_backgroundView insertSubview:_lastScreenShotView belowSubview:_blackMask];
            _rootNavJum = RootNavJumpPop;
        }
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (!_isMoving) {
            return;
        }
        _isMoving = NO;
        CGFloat destination;
        if (currentPoint.x - _initialPoint.x >= 50 && currentVelocity.x > 0) {
            destination = self.view.frame.size.width;
            _rootNavJum = _rootNavJum & RootNavJumpDefault;
        }else{
            destination = 0;
            _rootNavJum = _rootNavJum & RootNavJumpNone;
        }
        
        [UIView animateWithDuration:.25 animations:^{
            [self moveToX:destination];
        }completion:^(BOOL finished) {
            _backgroundView.hidden = YES;
            if (_rootNavJum & RootNavJumpPop) {
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
            }else if (_rootNavJum & RootNavJumpDismiss){
                [self dismissViewControllerAnimated:NO completion:^{
                    
                }];
            }
            [self dismissShadow];
        }];
    }else if (panGesture.state == UIGestureRecognizerStateCancelled) {
        if (!_isMoving) {
            return;
        }
        [UIView animateWithDuration:.25 animations:^{
            [self moveToX:0];
        } completion:^(BOOL finished) {
            _backgroundView.hidden = YES;
            _isMoving = NO;
            [self dismissShadow];
        }];
    }
    if (_isMoving) {
        [self moveToX:(currentPoint.x - _initialPoint.x)];
    }
}

#pragma mark - dealloc
- (void)dealloc{
    NSLog(@"RootNav dealloc");
}
@end
