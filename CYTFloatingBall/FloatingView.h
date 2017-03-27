//
//  FloatingView.h
//  CYTFloatingBall
//
//  Created by 。。。 on 2017/3/27.
//  Copyright © 2017年 isofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FRAME_WITH 100         // 浮窗宽度
#define FRAME_HEIGHT 100       // 浮窗高度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define animateDuration 0.3       //位置改变动画时间
#define normalAlpha  0.8           //正常状态时背景alpha值
#define sleepAlpha  0.3           //隐藏到边缘时的背景alpha值
#define statusChangeDuration  3.0    //状态改变时间

@interface FloatingView : UIView

+ (void)createFloatView;

@end
