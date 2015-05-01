//
//  ViewController.m
//  VCTransition
//
//  Created by zjsruxxxy3 on 15/4/30.
//  Copyright (c) 2015年 WR. All rights reserved.
//

#import "ViewController.h"
#import "Animator.h"

@interface ViewController ()<UINavigationControllerDelegate>

@property(nonatomic,strong)Animator *animator;

@property(nonatomic,strong)UIPercentDrivenInteractiveTransition *interactionController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(makePush)];
    
    self.navigationItem.rightBarButtonItem = barItem;
    
#warning !!!!---必须把导航控制器的代理设置好，才能运行代理方法
    self.navigationController.delegate = self;
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.navigationController.view addGestureRecognizer:panRecognizer];
    
    self.animator = [Animator new];
    
    self.navigationController.view.backgroundColor = [UIColor yellowColor];
    
}

-(void)makePush
{

    NSLog(@"%@",self.navigationController.viewControllers);
    
}

-(void)pan:(UIPanGestureRecognizer *)recognizer
{
    UIView* view = self.navigationController.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [recognizer locationInView:view];
        
        // 右处滑动有效
        if (location.x > CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count == 1)
        {
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc]init];
            
            UIViewController *viewC = [[UIViewController alloc]init];
            
            viewC.view.backgroundColor = [UIColor grayColor];
            
            [self.navigationController pushViewController:viewC animated:YES];
            
            NSLog(@"%@",self.navigationController.viewControllers);
            
        }
    }else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:view];
        
        CGFloat d = fabsf(translation.x/CGRectGetWidth(view.bounds));
        
        [self.interactionController updateInteractiveTransition:d];
        
    }else if( recognizer.state == UIGestureRecognizerStateEnded)
    {
        // 向左滑动 v为负，正方向为x轴方向
        if([recognizer velocityInView:view].x<0)
        {
            [self.interactionController finishInteractiveTransition];
        }else
        {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }

}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    Animator *animator = [[Animator alloc]init];
    
    self.animator = animator;
    
    // push 专用 UINavigationControllerOperationPush
    if (operation == UINavigationControllerOperationPush )
    {
        return self.animator;

    }
    
    return self.animator;
    
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}

@end
