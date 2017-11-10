//
//  UIViewController+KMNavigation.h
//  KMNavigationBarTransition
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KMNavigation)
/** 设置导航栏是否隐藏 */
- (void)km_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
