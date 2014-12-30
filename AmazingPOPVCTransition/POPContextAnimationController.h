//
//  POPContextAnimationController.h
//  AmazingUIAdvanceTest
//
//  Created by goguhuan on 12/29/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pop/POP.h>
#import "AnimatorTools.h"

        //put these delegate in different and proper position within animationxx,interactivexxx according to your needs.
@protocol POPContextAnimationControllerDelegate <NSObject>

- (void)transitionWillBegin;

- (void)transitionDidCompleted:(BOOL)completed;

@end

@protocol POPContextAnimationControllerDataSource <NSObject>

- (CGRect)sourceRect;

- (CGRect)destinationRect;

@end

@interface POPContextAnimationController : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning>

@property (nonatomic) NSTimeInterval animationDuration;
@property BOOL reverse;

@property BOOL interactionInProgress;

@property id<POPContextAnimationControllerDelegate> animationContextDelegate;
@property id<POPContextAnimationControllerDataSource> animationContextDataSource;

//subClass should complete these functions
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView masterView:(UIView *)masterView modalView:(UIView *)modalView;
- (void)interactTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView masterView:(UIView *)masterView modalView:(UIView *)modalView;
- (void)wireToView:(UIView *)view viewController:(UIViewController *)viewController;

@end
