//
//  KMNavigationBar.m
//  KMNavigationBarTransition
//
//  Created by KM on 2017/11/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMNavigationBar.h"

@interface KMNavigationBar ()

@property (nonatomic, strong) UIImageView *km_shadowImageView;

@property (nonatomic, strong) UIView *km_backgroundImageView;

@end

@implementation KMNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    self.km_shadowImageView.frame = [self shadowImageViewFrame];
    self.km_backgroundImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

-(CGRect)shadowImageViewFrame {
    CGFloat shadow_height = 0.5;
    if (self.km_shadowImage) {
        shadow_height = self.km_shadowImage.size.height;
    }
    return CGRectMake(0, self.bounds.origin.y, self.bounds.size.width, shadow_height);
}

#pragma mark - getter/setter -
- (UIImageView *)cfy_shadowImageView {
    if (nil == _km_shadowImageView) {
        _km_shadowImageView = [[UIImageView alloc] initWithFrame: [self shadowImageViewFrame]];
        [self addSubview:_km_shadowImageView];
        // 设置默认背景色，和NavigationBar.shadowImage默认背景色相同
        _km_shadowImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        if (self.km_shadowImage) {
            _km_shadowImageView.image = self.km_shadowImage;
        }
    }
    
    return _km_shadowImageView;
}

- (UIView *)cfy_backgroundImageView {
    if (nil == _km_backgroundImageView) {
        _km_backgroundImageView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_km_backgroundImageView];
        _km_backgroundImageView.backgroundColor = [UIColor clearColor];
        if (self.km_navigationBarBackgroundImage) {
            _km_backgroundImageView.backgroundColor = [UIColor colorWithPatternImage:self.km_navigationBarBackgroundImage];
        }
    }
    
    return _km_backgroundImageView;
}

- (void)setKm_shadowImage:(UIImage *)shadowImage {
    _km_shadowImage = shadowImage;
    _km_shadowImageView.image = shadowImage;
    UIColor *shadowImageColoer = [UIColor clearColor];
    if (!shadowImage) {
        shadowImageColoer = self.km_shadowImageColor;
    }
    self.km_shadowImageView.backgroundColor = shadowImageColoer;
    self.cfy_shadowImageView.frame = [self shadowImageViewFrame];
}

- (void)setKm_shadowImageColor:(UIColor *)shadowImageColor {
    if (!shadowImageColor) {
        shadowImageColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    _km_shadowImageColor = shadowImageColor;
    self.km_shadowImageView.backgroundColor = shadowImageColor;
    self.km_shadowImageView.frame = [self shadowImageViewFrame];
}

- (UIColor *)km_navigationBarBackgroundColor {
    if (nil == _km_navigationBarBackgroundColor) {
        _km_navigationBarBackgroundColor = [UIColor whiteColor];
    }
    return _km_navigationBarBackgroundColor;
}

- (void)setKm_navigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor {
    if (!navigationBarBackgroundColor) {
        navigationBarBackgroundColor = [UIColor whiteColor];
    }
    _km_navigationBarBackgroundColor = navigationBarBackgroundColor;
    self.backgroundColor = navigationBarBackgroundColor;
}

- (void)setKm_navigationBarBackgroundImage:(UIImage *)navigationBarBackgroundImage {
    _km_navigationBarBackgroundImage = navigationBarBackgroundImage;
    self.km_backgroundImageView.backgroundColor = [UIColor colorWithPatternImage:navigationBarBackgroundImage];
}


@synthesize km_navigationBarBackgroundColor = _km_navigationBarBackgroundColor;

@end
