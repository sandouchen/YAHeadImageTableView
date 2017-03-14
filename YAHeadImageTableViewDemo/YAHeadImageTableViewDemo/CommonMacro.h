//
//  CommonMacro.h
//  YAHeadImageTableViewDemo
//
//  Created by yinyao on 2017/3/13.
//  Copyright © 2017年 yinyao. All rights reserved.
//
//  GitHub: https://github.com/yaomars/YAHeadImageTableView


#ifndef CommonMacro_h
#define CommonMacro_h

// 屏幕宽度 高度 (注意，启动的时候窗口的创建不能用这个宏，6plus横屏启动会出错)
#define SCREENWIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
#define SCREENHEIGHT (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))

#endif /* CommonMacro_h */
