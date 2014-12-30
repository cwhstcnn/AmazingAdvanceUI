//
//  POPContextAnimationController.m
//  AmazingUIAdvanceTest
//
//  Created by goguhuan on 12/29/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "POPContextAnimationController.h"

@interface POPContextAnimationController()

@end

@implementation POPContextAnimationController

#pragma mark - Setter / Getter

- (NSTimeInterval)animationDuration
{
    if (_animationDuration < 1.0f) {
        _animationDuration = .3f;
    }
    return _animationDuration;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //prepare for all needed views
    UIView *containerView=[transitionContext containerView];
    UIView *masterView ;
    UIView *modalView ;
    
    //fix the differenc between ios7 and ios8
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        if (!self.reverse) {
            masterView=[transitionContext viewForKey:UITransitionContextFromViewKey];
            modalView=[transitionContext viewForKey:UITransitionContextToViewKey];
        }
        else {
            masterView=[transitionContext viewForKey:UITransitionContextToViewKey];
            modalView=[transitionContext viewForKey:UITransitionContextFromViewKey];
        }
    }
    else {
        if (!self.reverse) {
            masterView=fromVC.view;
            modalView=toVC.view;
        }
        else {
            masterView=toVC.view;
            modalView=fromVC.view;
        }
    }
    
    if (!self.interactionInProgress) {
        [self animateTransition:transitionContext containerView:containerView masterView:masterView modalView:modalView];
    }
    else {
        [self interactTransition:transitionContext containerView:containerView masterView:masterView modalView:modalView];
    }
}

#pragma mark - Subclass Should Implements

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView masterView:(UIView *)masterView modalView:(UIView *)modalView
{
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)interactTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView masterView:(UIView *)masterView modalView:(UIView *)modalView
{
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)wireToView:(UIView *)view viewController:(UIViewController *)viewController
{
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
