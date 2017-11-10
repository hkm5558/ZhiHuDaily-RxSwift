//
//  UIViewController+KMNavigation.m
//  KMNavigationBarTransition
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "UIViewController+KMNavigation.h"

#import "KMNavigationBar.h"
#import "KMSwizzleMethod.h"
#import "UIImage+KMNavigation.h"
#import "UINavigationController+KMNavigation_Public.h"
#import <objc/runtime.h>

#define KM_ScreenW [UIScreen mainScreen].bounds.size.width
#define KM_ScreenH [UIScreen mainScreen].bounds.size.height

@interface UIViewController ()

/** KMNavigationBar */
@property (nonatomic, strong) KMNavigationBar *km_navBarView;

/** 用来判断view是否加载 */
@property (nonatomic, assign) BOOL km_viewAppeared;

/** NavigationBar背景颜色 */
@property (nonatomic, strong) UIColor *km_navigationBarBackgroundColor;

/** NavigationBar背景图片 */
@property (nonatomic, strong) UIImage *km_navigationBarBackgroundImage;

/** NavigationBar颜色透明度 */
@property (nonatomic, assign) CGFloat km_navigationBarAlpha;

/** ShadowImage */
@property (nonatomic, strong) UIImage *km_shadowImage;

/** ShadowImageColor */
@property (nonatomic, strong) UIColor *km_shadowImageColor;

/** translationY */
@property (nonatomic, assign) CGFloat km_navigationBarTranslationY;

@end

@implementation UIViewController (KMNavigation)

/**
 在load中，swizzle四个方法viewDidLoad、viewWillLayoutSubviews、viewDidAppear:、viewDidDisappear:。
 */
+(void)load {
    KMSwizzleMethod(self, @selector(viewDidLoad), @selector(km_vc_viewDidLoad));
    KMSwizzleMethod(self, @selector(viewWillLayoutSubviews), @selector(km_vc_viewWillLayoutSubviews));
    KMSwizzleMethod(self, @selector(viewDidAppear:), @selector(km_vc_viewDidAppear:));
    KMSwizzleMethod(self, @selector(viewDidDisappear:), @selector(km_vc_viewDidDisappear:));
}

/**
 在viewDidLoad中添加km_navBarView
 */
- (void)km_vc_viewDidLoad {
    [self km_vc_viewDidLoad];
    // 如果存在navigationController则添加navBarView
    // 没有关闭使用本库的功能
    if (self.navigationController && !self.navigationController.isCloseKMNavigation) {
        [self km_addNavBarView];
    }
}

- (void)km_vc_viewDidAppear:(BOOL)animated {
    [self km_vc_viewDidAppear:animated];
    self.km_viewAppeared = YES;
}

- (void)km_vc_viewDidDisappear:(BOOL)animated {
    [self km_vc_viewDidDisappear:YES];
    self.km_viewAppeared = NO;
}

/**
 在viewWillLayoutSubviews中对km_navBarView进行处理，使km_navBarView能在不同环境正确显示
 */
- (void)km_vc_viewWillLayoutSubviews {
    [self km_vc_viewWillLayoutSubviews];
    // 关闭的本库的功能，直接退出
    if (self.navigationController.isCloseKMNavigation) {
        if (self.km_navBarView) {
            [self.km_navBarView removeFromSuperview];
        }
        return;
    }
    
    // 当前viewController没navigationController，直接退出
    // 关闭的本库的功能，直接退出
    if (!self.navigationController) {
        return;
    }
    /**
     self.navigationController.navigationBar隐藏了，做一些处理。
     如果在navigationBar隐藏时，旋转屏幕，这时如果不处理后并return，而是走下面的代码，那么并不能正确的获取到km_navBarView的frame。
     所以在这里直接将km_navBarView的宽度设置成屏幕看度，其他不变保持km_navBarView在隐藏前的状态，这样在从竖屏切换到横屏显示时不会出现一些视觉上的bug
     
     */
    if (self.navigationController.navigationBar.hidden) {
        CGRect rect = self.km_navBarView.frame;
        self.km_navBarView.frame = CGRectMake(0, rect.origin.y, KM_ScreenW, rect.size.height);
        return;
    }
    
    // 获取navigationBar的backgroundView
    UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    // 如果没有则return
    if (!backgroundView) {
        return;
    }
    
    
    // 获取navigationBar的backgroundView在self.view中的位置，这个位置也就是km_navBarView所在的位置。
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    
    // 出现rect.origin.x < 0,情况只有在页面刚push出来并且navigationBar隐藏的时候。
    // 这个时候讲rect.origin.y上移rect.size.height，使navBarView也隐藏
    // 目的是防止在navigationBar.hidden=NO时出现动画显示错误
    if (rect.origin.x < 0) {
        rect.origin.y = 0 - rect.size.height;
    }
    
    if (rect.origin.y > 0) {
        rect.size.height = rect.origin.y + rect.size.height;
        rect.origin.y = 0;
    }
    
    if (rect.origin.y == self.km_navigationBarTranslationY) {
        // km_navBarView的x固定0
        self.km_navBarView.frame = CGRectMake(0, rect.origin.y, rect.size.width, rect.size.height);
    }else{
        self.km_navBarView.transform = CGAffineTransformMakeTranslation(0, self.km_navigationBarTranslationY);
    }

    // 设置当前view的clipsToBounds = NO，原因是，self.view.top可能是从navigationBar.bottom开始，如果clipsToBounds = YES，则navBarView无法显示
    self.view.clipsToBounds = NO;
    // 将navBarView移到self.view最顶端，防止被其他view遮盖
    [self.view bringSubviewToFront:self.km_navBarView];
}

#pragma mark - 公开方法 -
/**
 设置导航栏背景色
 
 @param color 背景色
 */
- (void)km_setNavigationBarBackgroundColor:(UIColor *)color {
    self.km_navigationBarBackgroundColor = color;
    if (self.navigationController) {
        self.km_navBarView.km_navigationBarBackgroundColor = color;
    }
}

/**
 设置背景图片
 
 @param image 背景图
 */
- (void)km_setNavigationBarBackgroundImage:(UIImage *)image {
    self.km_navigationBarBackgroundImage = image;
    if (self.navigationController) {
        self.km_navBarView.km_navigationBarBackgroundImage = image;
    }
}

/**
 设置导航栏透明度
 
 @param alpha 透明度
 */
- (void)km_setNavigationBarAlpha:(CGFloat)alpha {
    self.km_navigationBarAlpha = alpha;
    if (self.navigationController) {
        self.km_navBarView.alpha = alpha;
    }
}

/**
 设置导航栏底部线条颜色
 
 @param color 线条颜色
 */
- (void)km_setNavigationBarShadowImageBackgroundColor:(UIColor *)color {
    self.km_shadowImageColor = color;
    if (self.navigationController) {
        self.km_navBarView.km_shadowImageColor = color;
    }
}


/**
 设置导航栏底部线条图片
 
 @param image 图片为nil时线条使用纯色
 */
- (void)km_setNavigationBarShadowImage:(UIImage * _Nullable )image {
    self.km_shadowImage = image;
    if (self.navigationController) {
        self.km_navBarView.km_shadowImage = image;
    }
}

- (void)km_setNavigationBarTranslationY:(CGFloat)translationY{
    self.km_navigationBarTranslationY = translationY;
    
    CGRect rect = self.navigationController.navigationBar.frame;
//    rect.origin.y += translationY;
//    self.navigationController.navigationBar.frame = rect;
//    self.km_navBarView.frame = rect;
    
    self.km_navBarView.transform = CGAffineTransformMakeTranslation(0, translationY);
//    if (self.navigationController) {
//        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
//    }
}

#pragma mark - 私有方法 -
/**
 设置导航栏是否隐藏
 
 @param hidden 隐藏
 @param animated 动画
 */
- (void)km_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (self.navigationController) {

        if (hidden && self.km_viewAppeared && animated && !self.navigationController.navigationBar.hidden) {
            // 在km_navBarView隐藏，并且view已经Appeared，并且有动画，并且navigationBar不是已经隐藏了时就进行动画
            CGRect rect = self.km_navBarView.frame;
            [UIView animateWithDuration:0.2 animations:^{
                // 动画时向上运动
                self.km_navBarView.frame = CGRectMake(0, rect.origin.y - rect.size.height, rect.size.width, rect.size.height);
            } completion:^(BOOL finished) {
                // 动画完成后km_navBarView隐藏
                self.km_navBarView.hidden = hidden;
            }];
        } else {
            self.km_navBarView.hidden = hidden;
        }
    }
}

/**
 添加navigationBar背景view
 */
- (void)km_addNavBarView {
    if (self.navigationController.isCloseKMNavigation) {
        return;
    }
    if (!self.isViewLoaded) {
        return;
    }
    if (!self.navigationController) {
        return;
    }
    if (!self.navigationController.navigationBar) {
        return;
    }
    
    // 获取NavigationBar的BackgroundView在当前view中的位置
    CGRect rect = [self km_getNavigationBarBackgroundViewRect];
    
    // 初始化
    KMNavigationBar *navBarView = [[KMNavigationBar alloc] initWithFrame:CGRectMake(0, rect.origin.y, rect.size.width, rect.size.height)];
    [self.view addSubview:navBarView];
    
    // 判断有没有设置颜色
    if (self.km_navigationBarBackgroundColor) {
        navBarView.km_navigationBarBackgroundColor = self.km_navigationBarBackgroundColor;
    } else {
        // 默认是白色
        navBarView.km_navigationBarBackgroundColor = [UIColor whiteColor];
        self.km_navigationBarBackgroundColor = [UIColor whiteColor];
    }
    // 设置图片
    navBarView.km_navigationBarBackgroundImage = self.km_navigationBarBackgroundImage;
    
    // 设置透明度，默认为1
    navBarView.alpha = self.km_navigationBarAlpha;
    if (self.km_shadowImage) {
        navBarView.km_shadowImage = self.km_shadowImage;
    }
    if (self.km_shadowImageColor) {
        navBarView.km_shadowImageColor = self.km_shadowImageColor;
    }
    // 是否隐藏
    navBarView.hidden = self.navigationController.navigationBar.isHidden;
    // 保存
    [self setKm_navBarView:navBarView];
}

/**
 获取navigationBar._backgroundView在self.view中的frame
 
 @return _backgroundView的frame
 */
- (CGRect)km_getNavigationBarBackgroundViewRect {
    UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    if (!backgroundView) {
        return CGRectZero;
    }
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    return rect;
}

#pragma mark - getter/setter -
-(KMNavigationBar *)km_navBarView {
    KMNavigationBar *navBarView = objc_getAssociatedObject(self, _cmd);
    
    if (nil == navBarView) {
        [self km_addNavBarView];
    }
    
    return navBarView;
}

- (void)setKm_navBarView:(KMNavigationBar *)navBarView {
    objc_setAssociatedObject(self, @selector(km_navBarView), navBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)km_viewAppeared {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKm_viewAppeared:(BOOL)viewAppeared {
    objc_setAssociatedObject(self, @selector(km_viewAppeared), @(viewAppeared), OBJC_ASSOCIATION_ASSIGN);
}

- (UIColor *)km_navigationBarBackgroundColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKm_navigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor {
    objc_setAssociatedObject(self, @selector(km_navigationBarBackgroundColor), navigationBarBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)km_navigationBarBackgroundImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKm_navigationBarBackgroundImage:(UIImage *)navigationBarBackgroundImage {
    objc_setAssociatedObject(self, @selector(km_navigationBarBackgroundImage), navigationBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)km_navigationBarAlpha {
    NSNumber *alpha = objc_getAssociatedObject(self, _cmd);
    if (!alpha) {
        [self setKm_navigationBarAlpha:1.0];
        return 1.0;
    }
    
    return [alpha floatValue];
}

- (void)setKm_navigationBarAlpha:(CGFloat)navigationBarAlpha {
    objc_setAssociatedObject(self, @selector(km_navigationBarAlpha), @(navigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//
- (void)setKm_navigationBarTranslationY:(CGFloat)translationY {
    objc_setAssociatedObject(self, @selector(km_navigationBarTranslationY), @(translationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)km_navigationBarTranslationY {
    NSNumber *translationY = objc_getAssociatedObject(self, _cmd);
    if (!translationY) {
        [self setKm_navigationBarTranslationY:0.0];
        return 0.0;
    }
    return [translationY floatValue];
}
//

- (void)setKm_shadowImage:(UIImage *)shadowImage {
    objc_setAssociatedObject(self, @selector(km_shadowImage), shadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)km_shadowImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIColor *)km_shadowImageColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKm_shadowImageColor:(UIColor *)shadowImageColor {
    objc_setAssociatedObject(self, @selector(km_shadowImageColor), shadowImageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
