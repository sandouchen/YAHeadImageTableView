//
//  UINavigationBar+AlphaAnimation.h
//
//  Created by yinyao on 2017/3/2.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (AlphaAnimation)

///设置背景颜色
- (void)ya_setBackgroundColor:(UIColor *)backgroundColor;

///设置导航栏中包含的视图元素的透明度
- (void)ya_setElementsAlpha:(CGFloat)alpha;

///重置导航栏为默认样式
- (void)ya_reset;

@end
