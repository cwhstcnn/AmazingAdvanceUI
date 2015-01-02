//
//  POPInteractiveAnimatedContextAnimationController.m
//  AmazingAdvanceUITest
//
//  Created by goguhuan on 1/2/15.
//  Copyright (c) 2015 goguhuan. All rights reserved.
//

#import "POPInteractiveAnimatedContextAnimationController.h"

static const CGFloat kTransitionGestureVelocityThreshold = 50.0f;
static const CGFloat kTransitionGestureLocationThreshold = 284.0f;

@interface POPInteractiveAnimatedContextAnimationController()<UIGestureRecognizerDelegate>

        // interactive animated transition
@property CGRect sourceRect;

@property CGRect destinationRect;

@property id<UIViewControllerContextTransitioning> transitionContext;

@property (assign, nonatomic) CGFloat percentComplete;
@property (assign, nonatomic) NSTimeInterval startingTime;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property UIView *view;

@property CGPoint intitialPosition;

@property UIView *modalView;
@property UIView *masterView;

@property UIPanGestureRecognizer *panGesture;

    // interactive transition
@property UIViewController *modalViewController;

@property BOOL interactiveInProgress;

@end

@implementation POPInteractiveAnimatedContextAnimationController

#pragma mark - Setter / Getter

- (NSTimeInterval)animationDuration
{
    if (_animationDuration < 1.0f) {
        _animationDuration = .3f;
    }
    return _animationDuration;
}

#pragma mark - Animated Transition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

#pragma mark - Interactive Transition

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
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
    
    self.transitionContext=transitionContext;
    self.modalView=modalView;
    self.masterView=masterView;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [containerView addGestureRecognizer:gesture];
    gesture.delegate = self;
    
    self.panGesture=gesture;
    
    self.startingTime = CACurrentMediaTime();
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    if (!self.reverse) {
        
        [containerView addSubview:modalView];
        
        CGRect sourceRect;
        if ([self.animationContextDataSource respondsToSelector:@selector(sourceRect)]) {
            sourceRect = [self.animationContextDataSource sourceRect];
        }
        
        CGRect destinationRect;
        if ([self.animationContextDataSource respondsToSelector:@selector(destinationRect)]) {
            destinationRect = [self.animationContextDataSource destinationRect];
        }
        
        UIImageView *snapshotFromMaster=[AnimatorTools cropFromImageView:[AnimatorTools snapshotFromView:masterView] fromRect:sourceRect];
        [containerView addSubview:snapshotFromMaster];
        
        modalView.alpha=0.0f;
        snapshotFromMaster.frame=sourceRect;
        
        self.view=snapshotFromMaster;
        self.sourceRect=sourceRect;
        self.destinationRect=destinationRect;
        
        POPSpringAnimation *moveToRectAnimation=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        moveToRectAnimation.springBounciness=10.0f;
        moveToRectAnimation.toValue=[NSValue valueWithCGRect:destinationRect];
        moveToRectAnimation.completionBlock=^(POPAnimation *animation, BOOL completed){

            [self.displayLink invalidate];
            
            if (completed) {
                
                [gesture.view removeGestureRecognizer:gesture];
                
                modalView.alpha=1.0f;
                [snapshotFromMaster removeFromSuperview];
                
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:YES];
            }
        };
        
        [snapshotFromMaster pop_addAnimation:moveToRectAnimation forKey:@"moveToRect"];
    }
    else {
        masterView.userInteractionEnabled=NO;
        [containerView addSubview:masterView];
        
        CGRect sourceRect;
        if ([self.animationContextDataSource respondsToSelector:@selector(destinationRect)]) {
            sourceRect = [self.animationContextDataSource destinationRect];
        }
        
        CGRect destinationRect;
        if ([self.animationContextDataSource respondsToSelector:@selector(sourceRect)]) {
            destinationRect = [self.animationContextDataSource sourceRect];
        }
        
        UIImageView *snapshotFromModal=[AnimatorTools cropFromImageView:[AnimatorTools snapshotFromView:modalView] fromRect:sourceRect];
        [containerView addSubview:snapshotFromModal];
        
        snapshotFromModal.frame=sourceRect;
        
        self.view=snapshotFromModal;
        self.sourceRect=sourceRect;
        self.destinationRect=destinationRect;
        
        POPSpringAnimation *moveToRectAnimation=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        moveToRectAnimation.springBounciness=10.0f;
        moveToRectAnimation.toValue=[NSValue valueWithCGRect:destinationRect];
        moveToRectAnimation.completionBlock=^(POPAnimation *animation, BOOL completed){
            
            [self.displayLink invalidate];
            
            if (completed) {
                
                self.masterView.userInteractionEnabled=YES;
                
                [gesture.view removeGestureRecognizer:gesture];
                
                [snapshotFromModal removeFromSuperview];
                
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:YES];
            }
        };
        
        [snapshotFromModal pop_addAnimation:moveToRectAnimation forKey:@"moveToRect"];
    }
}

#pragma mark - Update Transition Progress

- (void)tick:(CADisplayLink *)link
{
    NSTimeInterval elapedTime = link.timestamp - self.startingTime;
    NSTimeInterval duration = 0.5;
    
    self.percentComplete = MIN(1.0, elapedTime / duration);
    
    [self.transitionContext updateInteractiveTransition:self.percentComplete];
}

#pragma mark - Interactive Handle

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible:
        {
        }
            break;
        case UIGestureRecognizerStateBegan:
        {
            [self.view pop_removeAllAnimations];
            
            self.intitialPosition=self.view.layer.position;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:gesture.view];
            
            CGPoint centerTranslated = self.intitialPosition;
            centerTranslated.x += translation.x;
            centerTranslated.y += translation.y;
            
            self.view.layer.position = centerTranslated;
            
                    //should change the logic
            CGFloat percentComplete = MAX(MIN(self.view.center.y / 1000, 1.0), 0.0);
            
            if (self.reverse) percentComplete = 1.0f - percentComplete;
            
            [self.transitionContext updateInteractiveTransition:percentComplete];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
            CGPoint velocity = [gesture velocityInView:gesture.view];
            CGPoint location = [gesture locationInView:gesture.view];
            
            BOOL shouldFinish;
            
            if (ABS(velocity.y) > kTransitionGestureVelocityThreshold) {
                shouldFinish = velocity.y > 0;
            } else {
                shouldFinish = location.y > kTransitionGestureLocationThreshold;
            }
            
            if (shouldFinish) {

                    POPSpringAnimation *moveToRectAnimation=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                    moveToRectAnimation.springBounciness=10.0f;
                    moveToRectAnimation.toValue=[NSValue valueWithCGRect:self.destinationRect];
                    moveToRectAnimation.completionBlock=^(POPAnimation *animation, BOOL completed){
                        
                        if (completed) {
                            
                            [gesture.view removeGestureRecognizer:gesture];
                            
                            [self.view removeFromSuperview];
                            if (!self.reverse) {
                                self.modalView.alpha=1.0f;
                            }
                            else {
                                
                                self.masterView.userInteractionEnabled=YES;
                                
                                [self.modalView removeFromSuperview];
                            }
                            
                            [self.transitionContext finishInteractiveTransition];
                            [self.transitionContext completeTransition:YES];
                        }
                    };
                    
                    [self.view pop_addAnimation:moveToRectAnimation forKey:@"moveToRectAnimation"];
            }
            else {
                
                    POPSpringAnimation *moveToRectAnimation=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                    moveToRectAnimation.springBounciness=10.0f;
                    moveToRectAnimation.toValue=[NSValue valueWithCGRect:self.sourceRect];
                    moveToRectAnimation.completionBlock=^(POPAnimation *animation, BOOL completed){
                        
                        if (completed) {
                            
                            [gesture.view removeGestureRecognizer:gesture];
                            
                            [self.view removeFromSuperview];
                            if (!self.reverse) {
                                [self.modalView removeFromSuperview];
                            }
                            else {
                                [self.masterView removeFromSuperview];
                            }
                            
                            [self.transitionContext cancelInteractiveTransition];
                            [self.transitionContext completeTransition:NO];
                        }
                    };
                    
                    [self.view pop_addAnimation:moveToRectAnimation forKey:@"moveToRectAnimation"];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Enable Gesture In Proper Time

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer != self.panGesture) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self.transitionContext.containerView];
    
    CALayer *presentationLayer = self.view.layer.presentationLayer;
    
    if ([presentationLayer hitTest:location])
    {
        return YES;
    }else{
        return NO;  //the BOOL value return here can only control your pan gesture, can not cantrol the gesture from master view!!!
    }
}

#pragma mark - Add Gesture To Dismiss Modal Controller

- (void)wireToModalController:(UIViewController *)modalController
{
    self.modalViewController=modalController;
    
    UIPanGestureRecognizer *panToDismiss=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToDismiss:)];
    [modalController.view addGestureRecognizer:panToDismiss];
    
}

#pragma mark - Handle Gesture To Dismiss

- (void)panToDismiss:(UIPanGestureRecognizer *)gesture
{
    
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible:
        {
        }
            break;
        case UIGestureRecognizerStateBegan:
        {

            self.interactiveInProgress=YES;
            
            [self.modalViewController dismissViewControllerAnimated:YES completion:nil];
            
            self.intitialPosition=self.view.layer.position;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if ([self.view pop_animationForKey:@"moveToRect"]) {
                [self.view pop_removeAnimationForKey:@"moveToRect"];
            }
            if (self.interactiveInProgress) {
                
                CGPoint translation = [gesture translationInView:gesture.view];
                
                CGPoint centerTranslated = self.intitialPosition;
                centerTranslated.x += translation.x;
                centerTranslated.y += translation.y;
                
                self.view.layer.position = centerTranslated;
                
                //should change the logic
                CGFloat percentComplete = MAX(MIN(self.view.center.y / 1000, 1.0), 0.0);
                
                if (self.reverse) percentComplete = 1.0f - percentComplete;
                
                [self.transitionContext updateInteractiveTransition:percentComplete];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (self.interactiveInProgress) {
                
                self.interactiveInProgress = NO;
                
                CGPoint velocity = [gesture velocityInView:gesture.view];
                CGPoint location = [gesture locationInView:gesture.view];
                
                BOOL shouldFinish;
                
                if (ABS(velocity.y) > kTransitionGestureVelocityThreshold) {
                    shouldFinish = velocity.y > 0;
                } else {
                    shouldFinish = location.y > kTransitionGestureLocationThreshold;
                }
                
                if (shouldFinish) {
                    
                    POPSpringAnimation *moveToRectAnimation=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                    moveToRectAnimation.springBounciness=10.0f;
                    moveToRectAnimation.toValue=[NSValue valueWithCGRect:self.destinationRect];
                    moveToRectAnimation.completionBlock=^(POPAnimation *animation, BOOL completed){
                        
                        if (completed) {
                            
                            [gesture.view removeGestureRecognizer:gesture];
                            
                            [self.view removeFromSuperview];
                            if (!self.reverse) {
                                self.modalView.alpha=1.0f;
                            }
                            else {
                                
                                self.masterView.userInteractionEnabled=YES;
                                
                                [self.modalView removeFromSuperview];
                            }
                            
                            [self.transitionContext finishInteractiveTransition];
                            [self.transitionContext completeTransition:YES];
                        }
                    };
                    
                    [self.view pop_addAnimation:moveToRectAnimation forKey:@"moveToRectAnimation"];
                }
                else {
                    
                    POPSpringAnimation *moveToRectAnimation=[POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                    moveToRectAnimation.springBounciness=10.0f;
                    moveToRectAnimation.toValue=[NSValue valueWithCGRect:self.sourceRect];
                    moveToRectAnimation.completionBlock=^(POPAnimation *animation, BOOL completed){
                        
                        if (completed) {
                            
                                    //if cancelled, should not remove this gesture!!!
//                            [gesture.view removeGestureRecognizer:gesture];
                            
                            [self.view removeFromSuperview];
                            if (!self.reverse) {
                                [self.modalView removeFromSuperview];
                            }
                            else {
                                [self.masterView removeFromSuperview];
                            }
                            
                            [self.transitionContext cancelInteractiveTransition];
                            [self.transitionContext completeTransition:NO];
                        }
                    };
                    
                    [self.view pop_addAnimation:moveToRectAnimation forKey:@"moveToRectAnimation"];
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
        }
            break;
            
        default:
            break;
    }

}

@end
