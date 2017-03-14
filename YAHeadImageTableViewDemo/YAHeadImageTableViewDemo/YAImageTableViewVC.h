//
//  YAImageTableViewVC.h
//  YAHeadImageTableViewDemo
//
//  Created by yinyao on 2017/3/13.
//  Copyright © 2017年 yinyao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YAImageTableViewStyleOne,   //导航栏可透明,顶部图片可拉伸
    YAImageTableViewStyleTwo,   //导航栏可透明,文字可伸展收起,顶部图片下拉无弹性
} YAImageTableViewStyle;

@interface YAImageTableViewVC : UIViewController

/**
    导航栏标题
 */
@property (copy, nonatomic) NSString *navbarTitle;

/**
    头部展示类型
 */
@property (assign, nonatomic) YAImageTableViewStyle imageTableViewStyle;

@end
