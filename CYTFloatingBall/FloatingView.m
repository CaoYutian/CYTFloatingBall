//
//  FloatingView.m
//  CYTFloatingBall
//
//  Created by 。。。 on 2017/3/27.
//  Copyright © 2017年 isofoo. All rights reserved.
//

#import "FloatingView.h"

#define FRAME_WITH 100         // 浮窗宽度
#define FRAME_HEIGHT 100       // 浮窗高度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define animateDuration 0.3       //位置改变动画时间
#define normalAlpha  0.8           //正常状态时背景alpha值
#define sleepAlpha  0.3           //隐藏到边缘时的背景alpha值
#define statusChangeDuration  3.0    //状态改变时间

@interface FloatingView ()

@property(nonatomic,strong)UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIButton *versionButton;
@property (nonatomic, assign) BOOL isShowTab;

@end


@implementation FloatingView

// 类方法建立浮窗
+ (void)createFloatView{
    FloatingView *view = [[FloatingView alloc] initWithFrame:CGRectMake(-50, 100, FRAME_WITH, FRAME_HEIGHT)];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

#pragma mark - 创建ui
- (void)createUI {
    UIButton *versionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    versionButton.frame = CGRectMake(0, 0, FRAME_WITH, FRAME_HEIGHT);
    [self addSubview:versionButton];
    versionButton.clipsToBounds = YES;
    versionButton.layer.cornerRadius = FRAME_WITH/2;
    [versionButton setImage:[[UIImage imageNamed:@"版本信息"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    versionButton.alpha = sleepAlpha;
    _versionButton = versionButton;
    [_versionButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(locationChange:)];
    _pan.delaysTouchesBegan = NO;
    [self addGestureRecognizer:_pan];
    self.isShowTab = FALSE;
    
    UILabel *labal = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FRAME_WITH, 50)];
    labal.center = _versionButton.center;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    labal.text = [NSString stringWithFormat:@"测试版本\n%@", dictionary[@"CFBundleShortVersionString"]];
    [versionButton addSubview:labal];
    labal.font = [UIFont systemFontOfSize:16];
    labal.lineBreakMode = NSLineBreakByWordWrapping;
    labal.numberOfLines = 2;
    labal.backgroundColor = [UIColor grayColor];
    labal.textColor = [UIColor whiteColor];
    labal.textAlignment = NSTextAlignmentCenter;
    
}
#pragma mark - 改变位置信息
- (void)locationChange:(UIPanGestureRecognizer*)p {
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
        _versionButton.alpha = normalAlpha;
    }
    
    if(p.state == UIGestureRecognizerStateChanged){
        self.center = CGPointMake(panPoint.x, panPoint.y);
        
    }else if(p.state == UIGestureRecognizerStateEnded){
        //
        //        [self stopAnimation];
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
        
        if(panPoint.x <= kScreenWidth/2)
        {
            if(panPoint.y <= 40+FRAME_HEIGHT/2 && panPoint.x >= 20+FRAME_WITH/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, FRAME_HEIGHT/2);
                }];
            }
            else if(panPoint.y >= kScreenHeight-FRAME_HEIGHT/2-40 && panPoint.x >= 20+FRAME_WITH/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, kScreenHeight-FRAME_HEIGHT/2);
                }];
            }
            else if (panPoint.x < FRAME_WITH/2+20 && panPoint.y > kScreenHeight-FRAME_HEIGHT/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(FRAME_WITH/2, kScreenHeight-FRAME_HEIGHT/2);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y < FRAME_HEIGHT/2 ? FRAME_HEIGHT/2 :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(FRAME_WITH/2, pointy);
                }];
            }
        }
        else if(panPoint.x > kScreenWidth/2)
        {
            if(panPoint.y <= 40+FRAME_HEIGHT/2 && panPoint.x < kScreenWidth-FRAME_WITH/2-20 )
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, FRAME_HEIGHT/2);
                }];
            }
            else if(panPoint.y >= kScreenHeight-40-FRAME_HEIGHT/2 && panPoint.x < kScreenWidth-FRAME_WITH/2-20)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, kScreenHeight-FRAME_HEIGHT/2);
                }];
            }
            else if (panPoint.x > kScreenWidth-FRAME_WITH/2-20 && panPoint.y < FRAME_HEIGHT/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(kScreenWidth-FRAME_WITH/2, FRAME_HEIGHT/2);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y > kScreenHeight-FRAME_HEIGHT/2 ? kScreenHeight-FRAME_HEIGHT/2 :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(kScreenWidth-FRAME_WITH/2, pointy);
                }];
            }
        }
    }
    
    
}

#pragma mark - 改变状态
- (void)changeStatus
{
    [UIView animateWithDuration:1.0 animations:^{
        _versionButton.alpha = sleepAlpha;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat x = self.center.x < 20+FRAME_WITH/2 ? 0 :  self.center.x > kScreenWidth - 20 -FRAME_WITH/2 ? kScreenWidth : self.center.x;
        CGFloat y = self.center.y < 40 + FRAME_HEIGHT/2 ? 0 : self.center.y > kScreenHeight - 40 - FRAME_HEIGHT/2 ? kScreenHeight : self.center.y;
        
        //禁止停留在4个角
        if((x == 0 && y ==0) || (x == kScreenWidth && y == 0) || (x == 0 && y == kScreenHeight) || (x == kScreenWidth && y == kScreenHeight)){
            y = self.center.y;
        }
        self.center = CGPointMake(x, y);
    }];
}

#pragma mark - 按钮点击事件
- (void)click:(UITapGestureRecognizer*)p
{
    _versionButton.alpha = normalAlpha;
    //拉出悬浮窗
    if (self.center.x == 0) {
        self.center = CGPointMake(FRAME_HEIGHT/2, self.center.y);
    }else if (self.center.x == kScreenWidth) {
        self.center = CGPointMake(kScreenWidth - FRAME_HEIGHT/2, self.center.y);
    }else if (self.center.y == 0) {
        self.center = CGPointMake(self.center.x, FRAME_HEIGHT/2);
    }else if (self.center.y == kScreenHeight) {
        self.center = CGPointMake(self.center.x, kScreenHeight - FRAME_HEIGHT/2);
    }
}
@end
