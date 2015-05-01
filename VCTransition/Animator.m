//
//  Animator.m
//  VCTransition
//
//  Created by zjsruxxxy3 on 15/4/30.
//  Copyright (c) 2015年 WR. All rights reserved.
//

#import "Animator.h"
#define DuartionTime .8f

@interface Animator ()
@end

@implementation Animator


// 1 设置转场时间
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return DuartionTime;
    
}

// 2 设置转场的具体实现内容
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView]addSubview:toVC.view];
    
    toVC.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.transform = CGAffineTransformMakeScale(.1, .1);
        
        toVC.view.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        fromVC.view.transform = CGAffineTransformIdentity;

        // 场景转换结束后必须设置yes
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}



@end
