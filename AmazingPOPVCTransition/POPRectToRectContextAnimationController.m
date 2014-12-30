//
//  RectToRectContextAnimationController.m
//  AmazingUIAdvanceTest
//
//  Created by goguhuan on 12/29/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "POPRectToRectContextAnimationController.h"

@interface POPRectToRectContextAnimationController()

@property id<UIViewControllerContextTransitioning> transitionContext;
@property UIViewController *modalVC;
@property UIImageView *modalCropSnap;
@property UIView *containerView;
@property UIView *modalView;
@property UIView *masterView;

@property CGPoint startPoint;

@property BOOL shouldCompleteTransition;

@property CGFloat fraction;

@end

@implementation POPRectToRectContextAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView masterView:(UIView *)masterView modalView:(UIView *)modalView
{
    self.containerView=containerView;
    
    if (!self.reverse) {
        
        [containerView addSubview:modalView];
        
        UIView *dimmingView=[[UIView alloc] initWithFrame:containerView.bounds];
        dimmingView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        [containerView addSubview:dimmingView];
        
        CGRect sourceRect;
        if ([self.animationContextDataSource respondsToSelector:@selector(sourceRect)]) {
            sourceRect = [self.animationContextDataSource sourceRect];
        }
        UIImageView *masterSnap=[AnimatorTools cropFromImageView:[AnimatorTools snapshotFromView:masterView] fromRect:sourceRect];
        masterSnap.frame=sourceRect;
        [containerView addSubview:masterSnap];
        
        if ([self.animationContextDelegate respondsToSelector:@selector(transitionWillBegin)]) {
            [self.animationContextDelegate transitionWillBegin];
        }
        
        CGRect destinationRect;
        if ([self.animationContextDataSource respondsToSelector:@selector(destinationRect)]) {
            destinationRect = [self.animationContextDataSource destinationRect];
        }
        
        modalView.alpha=0.0f;
        POPSpringAnimation *springToRect=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        springToRect.springBounciness=10.0f;
        springToRect.toValue=[NSValue valueWithCGRect:destinationRect];
        springToRect.completionBlock=^(POPAnimation *animation, BOOL completed){
            
            if ([self.animationContextDelegate respondsToSelector:@selector(transitionDidCompleted:)]) {
                [self.animationContextDelegate transitionDidCompleted:completed];
            }
            
            POPSpringAnimation *springAlpha=[POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
            springAlpha.toValue=@(1.0f);
            springAlpha.completionBlock=^(POPAnimation *animatino, BOOL completed){
                
                [dimmingView removeFromSuperview];
                [masterSnap removeFromSuperview];
                
                
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            };
            [modalView pop_addAnimation:springAlpha forKey:@"alpha"];

        };
        [masterSnap pop_addAnimation:springToRect forKey:@"springToRect"];
    }
    else {
        [containerView addSubview:masterView];
        
        if ([self.animationContextDelegate respondsToSelector:@selector(transitionWillBegin)]) {
            [self.animationContextDelegate transitionWillBegin];
        }
        
        CGRect sourceRect;
        if ([self.animationContextDataSource respondsToSelector:@selector(destinationRect)]) {
            sourceRect = [self.animationContextDataSource destinationRect];
        }
        
        UIImageView *modalSnap=[AnimatorTools cropFromImageView:[AnimatorTools snapshotFromView:modalView] fromRect:sourceRect];
        modalSnap.frame=sourceRect;
        [containerView addSubview:modalSnap];
        
        CGRect destinationRect;
        if ([self.animationContextDataSource respondsToSelector:@selector(sourceRect)]) {
            destinationRect = [self.animationContextDataSource sourceRect];
        }
        
        POPSpringAnimation *springToRect=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        springToRect.springBounciness=5.0f;
        springToRect.toValue=[NSValue valueWithCGRect:destinationRect];
        springToRect.completionBlock=^(POPAnimation *animation, BOOL completed){
            
            [modalSnap removeFromSuperview];
            
            if ([self.animationContextDelegate respondsToSelector:@selector(transitionDidCompleted:)]) {
                [self.animationContextDelegate transitionDidCompleted:completed];
            }
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        };
        [modalSnap pop_addAnimation:springToRect forKey:@"springToRect"];
        
    }
}

- (void)wireToView:(UIView *)view viewController:(UIViewController *)viewController
{
    self.modalVC=viewController;
    
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [view addGestureRecognizer:panGesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint location=[gesture locationInView:self.containerView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.startPoint=location;
            
            self.interactionInProgress=YES;
            
            [self.modalVC.navigationController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            if (self.interactionInProgress) {
                
                CGPoint translation=[gesture translationInView:self.containerView];
                
                CGFloat fraction=(location.y - self.startPoint.y) / 100.0f;
                fraction=fabsf(fraction);
                if (fraction >= 1.0f) {
                    fraction = 0.99f;
                }
                self.fraction=fraction;
                self.shouldCompleteTransition=fraction > 0.5f;
                
                [self updateInteractiveTransition:fraction];
                
                CGPoint position=self.modalCropSnap.layer.position;
                position.x+=translation.x;
                position.y+=translation.y;
                self.modalCropSnap.layer.position=position;
                
                [gesture setTranslation:CGPointZero inView:self.containerView];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.interactionInProgress) {
                self.interactionInProgress = NO;
                
                if (!self.shouldCompleteTransition || gesture.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                    
                    CGPoint velocity=[gesture velocityInView:self.containerView];
                    
                    CGRect destinationRect;
                    if ([self.animationContextDataSource respondsToSelector:@selector(destinationRect)]) {
                        destinationRect = [self.animationContextDataSource destinationRect];
                    }
                    CGSize size=destinationRect.size;
                    CGPoint position=CGPointMake(destinationRect.origin.x + 0.5 * size.width, destinationRect.origin.y + 0.5 * size.height);
                    
                    UIView *dimmingView=[[UIView alloc] initWithFrame:self.containerView.bounds];
                    dimmingView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:1];
                    [self.containerView insertSubview:dimmingView belowSubview:self.modalCropSnap];
                    POPSpringAnimation *translate=[POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                    translate.toValue=[NSValue valueWithCGPoint:position];
                    translate.velocity=[NSValue valueWithCGPoint:velocity];
                    translate.completionBlock=^(POPAnimation *animation, BOOL completed){
                        
                            //make remove more natural
                        POPSpringAnimation *dimmingSpringAlpha=[POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
                        dimmingSpringAlpha.toValue=@(0);
                        dimmingSpringAlpha.completionBlock=^(POPAnimation *animation, BOOL completed){
                            [self.modalCropSnap removeFromSuperview];
                            [dimmingView removeFromSuperview];
                        };
                        [dimmingView pop_addAnimation:dimmingSpringAlpha forKey:@"dimmingAlpha"];

                        [self.transitionContext completeTransition:NO];
                    };
                    
                    [self.modalCropSnap pop_addAnimation:translate forKey:@"translate"];
                }
                else {
                    [self finishInteractiveTransition];
                    
                    CGPoint velocity=[gesture velocityInView:self.containerView];
                    
                    CGRect destinationRect;
                    if ([self.animationContextDataSource respondsToSelector:@selector(sourceRect)]) {
                        destinationRect = [self.animationContextDataSource sourceRect];
                    }
                    CGSize size=destinationRect.size;
                    CGPoint position=CGPointMake(destinationRect.origin.x + 0.5 * size.width, destinationRect.origin.y + 0.5 * size.height);
                    
                    POPSpringAnimation *scale=[POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
                    scale.toValue=[NSValue valueWithCGRect:CGRectMake(0, 0, size.width, size.height)];
                    scale.springBounciness=10;
                    
                    POPSpringAnimation *translate=[POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                    translate.toValue=[NSValue valueWithCGPoint:position];
                    translate.velocity=[NSValue valueWithCGPoint:velocity];
                    translate.completionBlock=^(POPAnimation *animation, BOOL complete){
                        
                        [self.modalCropSnap removeFromSuperview];
                        
                        if ([self.animationContextDelegate respondsToSelector:@selector(transitionDidCompleted:)]) {
                            [self.animationContextDelegate transitionDidCompleted:complete];
                        }
                        
                        [self.transitionContext completeTransition:YES];
                    };
                    
                    [self.modalCropSnap pop_addAnimation:scale forKey:@"scale"];
                    [self.modalCropSnap pop_addAnimation:translate forKey:@"translate"];
                }
            }

            break;
        default:
            break;
    }
    
}

- (CGFloat)completionSpeed
{
    return (1-self.fraction) * self.animationDuration;
}

- (void)interactTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView *)containerView masterView:(UIView *)masterView modalView:(UIView *)modalView
{
    self.transitionContext=transitionContext;
    self.modalView=modalView;
    self.containerView=containerView;
    self.masterView=masterView;
    
    if ([self.animationContextDelegate respondsToSelector:@selector(transitionWillBegin)]) {
        [self.animationContextDelegate transitionWillBegin];
    }
    
    [containerView addSubview:masterView];
    
    
    CGRect sourceRect;
    if ([self.animationContextDataSource respondsToSelector:@selector(destinationRect)]) {
        sourceRect = [self.animationContextDataSource destinationRect];
    }
    
    UIImageView *modalSnap=[AnimatorTools cropFromImageView:[AnimatorTools snapshotFromView:modalView] fromRect:sourceRect];
    modalSnap.frame=sourceRect;
    [containerView addSubview:modalSnap];
    
    self.modalCropSnap=modalSnap;
}


@end
