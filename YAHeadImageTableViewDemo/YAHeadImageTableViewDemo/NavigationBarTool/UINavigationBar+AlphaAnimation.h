//
//  UINavigationBar+AlphaAnimation.h
//  ZQFNewMedia
//
//  Created by yinyao on 2017/3/2.
//  Copyright © 2017年 深圳市正前方新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (AlphaAnimation)

- (void)ya_setBackgroundColor:(UIColor *)backgroundColor;
- (void)ya_setElementsAlpha:(CGFloat)alpha;
- (void)ya_setTranslationY:(CGFloat)translationY;
- (void)ya_reset;

@end
