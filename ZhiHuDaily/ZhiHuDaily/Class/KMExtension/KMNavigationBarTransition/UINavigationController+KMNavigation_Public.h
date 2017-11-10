//
//  UINavigationController+KMNavigation_Public.h
//  KMNavigationBarTransition
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (KMNavigation_Public)

/**
 设置导航栏背景色
 
 @param color 背景色
 */
- (void)km_setNavigationBarBackgroundColor:(UIColor *)color;

/**
 设置背景图片
 
 @param image 背景图
 */
- (void)km_setNavigationBarBackgroundImage:(UIImage * _Nullable )image;

/**
 设置导航栏透明度
 
 @param alpha 透明度，值为0 ~ 1.0
 */
- (void)km_setNavigationBarAlpha:(CGFloat)alpha;

/**
 设置导航栏底部线条颜色
 
 @param color 线条颜色,color为nil时，使用默认颜色RGBA(0, 0, 0, 0.3)
 */
- (void)km_setNavigationBarShadowImageBackgroundColor:(UIColor * _Nullable )color;



/**
 设置导航栏底部线条图片
 
 @param image 图片为nil时线条使用纯色
 */
- (void)km_setNavigationBarShadowImage:(UIImage * _Nullable )image;

- (void)km_setNavigationBarTranslationY:(CGFloat)translationY;


/**
 bar背景色
 */
@property (readonly) UIColor *km_navigationBarBackgroundColor;

/**
 保存navigationBar背景图片
 */
@property (readonly) UIImage *km_navigationBarBackgroundImage;

/**
 bar透明度
 */
@property (readonly) CGFloat km_navigationBarAlpha;

/**
 shadowImage
 */
@property (readonly) UIImage *km_shadowImage;

/**
 shadowImageColor
 */
@property (readonly) UIColor *km_shadowImageColor;

@property (readonly) CGFloat km_navigationBarTranslationY;

@end

@interface UINavigationController (KMNavigationBarTransition_Public)
/**
 关闭库的功能
 
 @param close 是否关闭
 */
- (void)closeKMNavigationFunction:(BOOL)close;


/**
 是否关闭
 */
@property (readonly) BOOL isCloseKMNavigation;

@end

NS_ASSUME_NONNULL_END
