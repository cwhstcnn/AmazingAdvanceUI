//
//  POPInteractiveAnimatedContextAnimationController.h
//  AmazingAdvanceUITest
//
//  Created by goguhuan on 1/2/15.
//  Copyright (c) 2015 goguhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimatorTools.h"

@protocol POPInteractiveAnimatedContextAnimationControllerDelegate <NSObject>

- (void)transitionWillBegin;

- (void)transitionDidCompleted:(BOOL)completed;

@end

@protocol POPInteractiveAnimatedContextAnimationControllerrDataSource <NSObject>

- (CGRect)sourceRect;

- (CGRect)destinationRect;

@end

@interface POPInteractiveAnimatedContextAnimationController : NSObject<UIViewControllerInteractiveTransitioning,UIViewControllerAnimatedTransitioning>

@property (nonatomic) NSTimeInterval animationDuration;
@property BOOL reverse;

@property id<POPInteractiveAnimatedContextAnimationControllerDelegate> animationContextDelegate;
@property id<POPInteractiveAnimatedContextAnimationControllerrDataSource> animationContextDataSource;

- (void)wireToModalController:(UIViewController *)modalController;

@end
