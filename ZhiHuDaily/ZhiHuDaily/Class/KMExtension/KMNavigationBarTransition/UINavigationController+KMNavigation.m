//
//  UINavigationController+KMNavigation.m
//  KMNavigationBarTransition
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "UINavigationController+KMNavigation.h"
#import "KMSwizzleMethod.h"
#import "UIImage+KMNavigation.h"
#import "UIViewController+KMNavigation.h"
#import "UINavigationController+KMNavigation_Public.h"
#import <objc/runtime.h>

@interface UINavigationController ()

/** 是否关闭 */
@property (readonly) BOOL closeKMNavigation;

@end

@implementation UINavigationController (KMNavigation)

+ (void)load {
    KMSwizzleMethod(self, @selector(viewDidLoad), @selector(km_navvc_viewDidLoad));
    KMSwizzleMethod(self, @selector(setNavigationBarHidden:animated:), @selector(km_setNavigationBarHidden:animated:));
    KMSwizzleMethod(self, @selector(setNavigationBarHidden:), @selector(km_setNavigationBarHidden:));
    KMSwizzleMethod(self, @selector(pushViewController:animated:), @selector(km_pushViewController:animated:));
}

- (void)km_navvc_viewDidLoad {
    [self km_navvc_viewDidLoad];
    // 没关闭
    if (!self.closeKMNavigation) {
        // 设置navigationBar为透明，但是如果navigationBar.translucent = NO，那么下面这句话就不起作用，navigationBar就会变成不透明的白色，所以不要设置navigationBar.translucent = NO
        [self.navigationBar setBackgroundImage:[UIImage km_imageWithColor:[UIColor clearColor]] forBarPosition:0 barMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)km_setNavigationBarHidden:(BOOL)hidden {
    // 没有关闭
    if (!self.closeKMNavigation) {
        UIViewController *vc = [self.viewControllers lastObject];
        // 先隐藏/显示barBgView
        [vc km_setNavigationBarHidden:hidden animated:NO];
    }
    
    // 再隐藏/显示navigationBar
    [self km_setNavigationBarHidden:hidden];
}

- (void)km_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    // 没有关闭本库
    if (!self.closeKMNavigation) {
        UIViewController *vc = [self.viewControllers lastObject];
        // 先隐藏/显示barBgView
        [vc km_setNavigationBarHidden:hidden animated:animated];
    }
    // 再隐藏/显示navigationBar
    [self km_setNavigationBarHidden:hidden animated:animated];
}

- (void)km_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 0) {
        [self km_pushViewController:viewController animated:animated];
        return;
    }
    
    // 没有关闭
    if (!self.closeKMNavigation) {
        UIViewController *fromVC = [self.viewControllers lastObject];
        // push时如果下一个页面没有设置背景色和透明度，那么会自动沿用当前页面的颜色和透明度。
        // 保存当前页面的bar颜色
        UIColor *bgColor = fromVC.km_navigationBarBackgroundColor;
        [viewController km_setNavigationBarBackgroundColor:bgColor];
        // 保存当前页面的bar图片
        UIImage *bgImage = fromVC.km_navigationBarBackgroundImage;
        [viewController km_setNavigationBarBackgroundImage:bgImage];
        // 保存当前页面的透明度
        CGFloat alpha = fromVC.km_navigationBarAlpha;
        [viewController km_setNavigationBarAlpha:alpha];
        // 保存shadowImage
        UIImage *shadowImage = fromVC.km_shadowImage;
        [viewController km_setNavigationBarShadowImage:shadowImage];
        // 保存shadowImageColor
        UIColor *shadowImageColor = fromVC.km_shadowImageColor;
        [viewController km_setNavigationBarShadowImageBackgroundColor:shadowImageColor];
    }
    
    
    
    // 保存完成开始Push
    [self km_pushViewController:viewController animated:animated];
}

- (void)closeKMNavigationFunction:(BOOL)close {
    self.closeKMNavigation = close;
    if (close) {
        [self.navigationBar setBackgroundImage:nil forBarPosition:0 barMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:nil];
    }
}


- (void)setCloseKMNavigation:(BOOL)closeKMNavigation {
    objc_setAssociatedObject(self, @selector(closeKMNavigation), @(closeKMNavigation), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)closeKMNavigation {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)isCloseKMNavigation {
    return [objc_getAssociatedObject(self, @selector(closeKMNavigation)) boolValue];
}


@end
