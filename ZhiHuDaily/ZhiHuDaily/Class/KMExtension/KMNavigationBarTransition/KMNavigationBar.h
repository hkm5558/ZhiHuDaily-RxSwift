//
//  KMNavigationBar.h
//  KMNavigationBarTransition
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMNavigationBar : UIView

/**
 shadowImage图片
 可以为nil,为nil时使用背景色
 */
@property (nonatomic, strong) UIImage *km_shadowImage;

/**
 shadowImage的颜色
 cfy_shadowImage为null时才显示颜色
 */
@property (nonatomic, strong) UIColor *km_shadowImageColor;

/**
 保存navigationBar颜色
 */
@property (nonatomic, strong) UIColor *km_navigationBarBackgroundColor;


/**
 保存navigationBar图片
 */
@property (nonatomic, strong) UIImage *km_navigationBarBackgroundImage;

@end
