//
//  UMSlideNavigationController.m
//  SegmentFault
//
//  Created by jiajun on 11/26/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#define ANIMATION_DURATION              0.3f
#define SILENT_DISTANCE                 30.0f
#define SLIDE_VIEW_WIDTH                260.0f

#import "UMSlideNavigationController.h"
#import "UMViewController.h"

@interface UMSlideNavigationController ()

////////////////////////////////////////////////////////////////////////////////////////////////////
// 可以滑动的View
@property (strong, nonatomic)   UIView            *contentView;
// 标记ContentView的静止状态left
@property (assign, nonatomic)   CGFloat           left;
// 标记滑动状态 0，手指还没动；1，手指开始滑动，但View没动；2，View已经开始滑动
@property (assign, nonatomic)   NSInteger         moving;

// 添加手势识别
- (void)addPanRecognizer;
// 动画
- (void)moveContentViewTo:(CGPoint)toPoint
                 WithPath:(UIBezierPath *)path
               inDuration:(CGFloat)duration;
// 左上角导航键
- (void)slideButtonClicked;
- (void)slideNavigatorDidDisappear;
- (void)slideNavigatorDidAppear;
// 滑动控制
- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer;
// 没有切换
- (void)switchCurrentView;

@end

@implementation UMSlideNavigationController

@synthesize contentView     = _contentView;
@synthesize currentIndex    = _currentIndex;
@synthesize items           = _items;
@synthesize left            = _left;
@synthesize navItem         = _navItem;
@synthesize slideView       = _slideView;

#pragma mark - private

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addPanRecognizer
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(slidePanAction:)];
    [self.contentView addGestureRecognizer:panRecognizer];
    self.left = self.contentView.left;
}

- (void)moveContentViewTo:(CGPoint)toPoint WithPath:(UIBezierPath *)path inDuration:(CGFloat)duration
{
    self.contentView.layer.anchorPoint = CGPointZero;
    self.contentView.layer.frame = CGRectMake(toPoint.x, toPoint.y,
                                              self.contentView.width, self.contentView.height);
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = duration;
    pathAnimation.path = path.CGPath;
    pathAnimation.calculationMode = kCAAnimationLinear;
    [self.contentView.layer addAnimation:pathAnimation
                                  forKey:[NSString stringWithFormat:@"%f",
                                          [NSDate timeIntervalSinceReferenceDate]]];
    self.left = toPoint.x;
    
    if (0 > toPoint.x) {
        UIControl *backToNormal = (UIControl *)[self.contentView viewWithTag:SLIDE_CONTROL_TAG];
        if (nil == backToNormal) {
            backToNormal = [[UIControl alloc] initWithFrame:self.contentView.bounds];
        }
        backToNormal.backgroundColor = [UIColor clearColor];
        backToNormal.tag = SLIDE_CONTROL_TAG;
        [backToNormal addTarget:self
                         action:@selector(slideButtonClicked)
               forControlEvents:UIControlEventTouchUpInside];
        [backToNormal removeFromSuperview];
        [self.contentView addSubview:backToNormal];
        [self performSelector:@selector(slideNavigatorDidAppear)
                   withObject:nil afterDelay:duration];
    }
    else {
        __weak UIControl *backToNormal = (UIControl *)[self.contentView
                                                       viewWithTag:SLIDE_CONTROL_TAG];
        [backToNormal removeFromSuperview];
        [self performSelector:@selector(slideNavigatorDidDisappear)
                   withObject:nil afterDelay:duration];
    }
    self.moving = 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)slideButtonClicked
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
    self.moving = 1;
    if (0.0f > self.contentView.left) { // 打开 -> 关闭
        [self viewWillDisappear:YES];
        [path addLineToPoint:CGPointMake(- self.contentView.width, 0.0f)];
        [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
        [self moveContentViewTo:CGPointMake(0.0f, 0.0f)
                       WithPath:path
                     inDuration:ANIMATION_DURATION + 0.2];
    }
    else { // 关闭 -> 打开
        [self viewWillAppear:YES];
        [path addLineToPoint:CGPointMake(- SLIDE_VIEW_WIDTH, 0.0f)];
        [self moveContentViewTo:CGPointMake(- SLIDE_VIEW_WIDTH, 0.0f)
                       WithPath:path
                     inDuration:ANIMATION_DURATION];
    }
}

// 延迟运行
- (void)slideNavigatorDidDisappear
{
    [self viewDidDisappear:YES];
}

- (void)slideNavigatorDidAppear
{
    [self viewDidAppear:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.contentView];
    CGPoint velocity = [recognizer velocityInView:self.contentView];
    if(recognizer.state == UIGestureRecognizerStateChanged
       && 2 <= ABS(self.left - ABS(translation.x))) { // 活动ing，每2个像素操作一次.
        if (0 >= self.moving) {
            if (0 <= self.left) {
                [self viewWillAppear:YES];
            }
            else {
                [self viewWillDisappear:YES];
            }
        }
        self.moving = (self.moving) ? self.moving : 1;
        CGFloat newLeft = self.left + translation.x;
        if (0 < newLeft) { // 只能向左滑动
            newLeft = 0;
        }
        else if (SLIDE_VIEW_WIDTH < ABS(newLeft)) { // 滑到最终位置
            newLeft = - SLIDE_VIEW_WIDTH;
        }
        if ((2 == self.moving) || (SILENT_DISTANCE < ABS(translation.x))) { // 滑动超过阀值，开始动
            self.contentView.left = newLeft;
            self.moving = 2;
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded) { // end slide.
        CGFloat animationDuration = 0.0f;
        CGFloat v = SLIDE_VIEW_WIDTH / ANIMATION_DURATION;
        if (0 < velocity.x) { // left to right
            // fast or more than half
            if (500.0f < velocity.x
                || SLIDE_VIEW_WIDTH / 2 > ABS(self.left + translation.x)) {
                animationDuration = (SLIDE_VIEW_WIDTH - translation.x) / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
                [self moveContentViewTo:CGPointMake(0.0f, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
            else if (0 > self.left && SLIDE_VIEW_WIDTH / 2 <= ABS(self.left + translation.x)) {
                animationDuration = translation.x / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(- SLIDE_VIEW_WIDTH, 0.0f)];
                [self moveContentViewTo:CGPointMake(- SLIDE_VIEW_WIDTH, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
        }
        else { // right to left
            // fast or more than half
            if (-500.0f > velocity.x || SLIDE_VIEW_WIDTH / 2 < ABS(self.left + translation.x)) {
                animationDuration = (SLIDE_VIEW_WIDTH + translation.x) / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(- SLIDE_VIEW_WIDTH, 0.0f)];
                [self moveContentViewTo:CGPointMake(- SLIDE_VIEW_WIDTH, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
            else if (SLIDE_VIEW_WIDTH / 2 >= ABS(self.left + translation.x)) {
                animationDuration = - translation.x / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
                [self moveContentViewTo:CGPointMake(0.0f, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)switchCurrentView
{
    [self.contentView removeAllSubviews];
    UIViewController *currentVC
    = (UIViewController *)self.items[self.currentIndex.section][self.currentIndex.row];
    [self.contentView addSubview:currentVC.view];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
    [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
    [self moveContentViewTo:CGPointMake(0.0f, 0.0f) WithPath:path inDuration:ANIMATION_DURATION];
    
#warning 阴影位置
    /**
    // 每次切换会清空contentView，这里重新贴阴影
    UIImageView *shadow = [[UIImageView alloc] initWithImage:
     [UIImage imageNamed:@"slide_navigator_shadow.png"]];
    shadow.height = self.contentView.height;
    shadow.right = self.contentView.left;
    [self.contentView addSubview:shadow];
     **/
}

#pragma mark - public

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc] init];
        for (NSArray *section in items) {
            [self.items addObject:[section mutableCopy]];
        }
        return self;
    }
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showItemAtIndex:(NSIndexPath *)index withAnimation:(BOOL)animated
{
    if (animated) {
        if (index.section < [self.items count] && index.row < [self.items[index.section] count]) {
            [self viewWillAppear:YES];
            self.currentIndex = index;
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
            [path addLineToPoint:CGPointMake(- self.contentView.width, 0.0f)];
            [self moveContentViewTo:CGPointMake(- self.contentView.width, 0.0f)
                           WithPath:path inDuration:0.2f];
            [self performSelector:@selector(switchCurrentView) withObject:nil afterDelay:0.2f];
        }
    }
    else {
        if (index.section < [self.items count] && index.row < [self.items[index.section] count]) {
            self.currentIndex = index;
            [self.contentView removeAllSubviews];

            UIViewController *currentVC
            = (UIViewController *)self.items[self.currentIndex.section][self.currentIndex.row];
            [self.contentView addSubview:currentVC.view];
            
#warning 阴影位置
    /**
     // 每次切换会清空contentView，这里重新贴阴影
            UIImageView *shadow = [[UIImageView alloc]
                                   initWithImage:[UIImage imageNamed:@"slide_navigator_shadow.png"]];
            shadow.height = self.contentView.height;
            shadow.right = self.contentView.left;
            [self.contentView addSubview:shadow];
     **/
        }
    }
}

#pragma mark

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navItem = [[UINavigationItem alloc] initWithTitle:@""];
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UIImageView *shadow = [[UIImageView alloc]
                           initWithImage:[UIImage imageNamed:@"slide_navigator_shadow.png"]];
    shadow.height = self.contentView.height;
    shadow.left = self.contentView.right - 1.0f;
    [self.contentView addSubview:shadow];
    
    self.slideView = [[UITableView alloc]
                      initWithFrame:CGRectMake(self.view.width - SLIDE_VIEW_WIDTH,
                                               20.0f,
                                               SLIDE_VIEW_WIDTH,
                                               self.view.height)
                      style:UITableViewStylePlain];
    
    if (0 < self.items.count) {
        [self.contentView addSubview:[(UIViewController *)self.items[0][0] view]];
    }
    
    [self.view addSubview:self.slideView];
    [self.view addSubview:self.contentView];
    
    [self addPanRecognizer];
    
    self.currentIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    self.slideView.hidden = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UMNotificationWillShow object:nil];
    self.slideView.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UMNotificationHidden object:nil];
    self.slideView.hidden = YES;
}

@end
