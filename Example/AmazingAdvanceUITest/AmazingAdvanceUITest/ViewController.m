//
//  ViewController.m
//  AmazingAdvanceUITest
//
//  Created by goguhuan on 12/30/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "ViewController.h"
#import "POPAnimationController.h"
#import "CollectionViewCell.h"
#import "DetailViewController.h"

#define VCCOLLECTIONVIEWCELLID @"cell"

typedef NS_OPTIONS(NSUInteger, AnimationControllerType)
{
    AnimationControllerUnknown,
    RectToRect,
    InteractiveRectToRect
};

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,POPContextAnimationControllerDataSource,POPContextAnimationControllerDelegate,UINavigationControllerDelegate,POPInteractiveAnimatedContextAnimationControllerDelegate,POPInteractiveAnimatedContextAnimationControllerrDataSource,UIViewControllerTransitioningDelegate>

@property UICollectionView *collectionView;

@property POPRectToRectContextAnimationController *rectToRectAnimationController;

@property POPInteractiveAnimatedContextAnimationController *interactiveAnimatedAnimationController;

@property AnimationControllerType animationControllerType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.delegate=self;
    
    [self addSubCollectionView];
    
    self.animationControllerType=InteractiveRectToRect;
}

#pragma mark - Context Animation DataSource

- (CGRect)sourceRect
{
    UIView *sourceView=[self selectedCell];
    CGRect sourceRect=[sourceView convertRect:sourceView.bounds toView:nil];
    return sourceRect;
}

- (CGRect)destinationRect
{
    CGRect destinationRect=CGRectMake(384-300, 400-300, 600, 600);
    return destinationRect;
}

- (void)transitionWillBegin
{
    UIView *sourceView=[self selectedCell];
    sourceView.hidden=YES;
}

- (void)transitionDidCompleted:(BOOL)completed
{
    UIView *sourceView=[self selectedCell];
    sourceView.hidden=NO;
}

- (UICollectionViewCell *)selectedCell
{
    
    NSIndexPath *selectedIndexPath=[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
    UICollectionViewCell *selectedCell=[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
    
    return selectedCell;
}

#pragma mark - Add SubViews

- (void)addSubCollectionView
{
    UICollectionViewFlowLayout *collectionViewLayout=[[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.itemSize=CGSizeMake(252, 312);
    collectionViewLayout.minimumInteritemSpacing=5;
    collectionViewLayout.minimumLineSpacing=5;
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionViewLayout];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    
    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:VCCOLLECTIONVIEWCELLID];
    
    collectionView.backgroundColor=[UIColor whiteColor];
    
    self.collectionView=collectionView;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}


#pragma mark - Collection View Implements

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell=(CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:VCCOLLECTIONVIEWCELLID forIndexPath:indexPath];
    cell.backgroundColor=[self randomColor];
    cell.cellLabel.text=[NSString stringWithFormat:@"%d",indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self tap:nil];
}

#pragma mark - Private

- (UIColor *)randomColor
{
    CGFloat red=arc4random()%255;
    CGFloat green=arc4random()%255;
    CGFloat blue=arc4random()%255;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}


- (void)tap:(UITapGestureRecognizer *)gesture
{
    DetailViewController *detailVC=[[DetailViewController alloc] init];
    detailVC.modalPresentationStyle=UIModalPresentationFullScreen;
    
    switch (self.animationControllerType) {
        case RectToRect:
        {
            POPRectToRectContextAnimationController *rectToRectContextAnimationController=[[POPRectToRectContextAnimationController alloc] init];
            rectToRectContextAnimationController.animationContextDataSource=self;
            [rectToRectContextAnimationController wireToView:detailVC.view viewController:detailVC];
            rectToRectContextAnimationController.animationContextDelegate=self;
            
            self.rectToRectAnimationController=rectToRectContextAnimationController;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case InteractiveRectToRect:
        {
            POPInteractiveAnimatedContextAnimationController *interactiveAnimatedAnimationController=[[POPInteractiveAnimatedContextAnimationController alloc] init];
            interactiveAnimatedAnimationController.animationContextDataSource=self;
            [interactiveAnimatedAnimationController wireToModalController:detailVC];            interactiveAnimatedAnimationController.animationContextDelegate=self;
            
            self.interactiveAnimatedAnimationController=interactiveAnimatedAnimationController;
            
            detailVC.transitioningDelegate=self;
            self.view.userInteractionEnabled=NO;
            [self presentViewController:detailVC animated:YES completion:^{
                self.view.userInteractionEnabled=YES;
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Transitioning Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    switch (self.animationControllerType) {
        case RectToRect:
        {
            self.rectToRectAnimationController.reverse=NO;
            return self.rectToRectAnimationController;
        }
            break;
        case InteractiveRectToRect:
        {
            self.interactiveAnimatedAnimationController.reverse=NO;
            return self.interactiveAnimatedAnimationController;
        }
            break;
            
            
        default:
            break;
    }
    
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    
    switch (self.animationControllerType) {
        case RectToRect:
        {
            self.rectToRectAnimationController.reverse=YES;
            return self.rectToRectAnimationController;
        }
            break;
        case InteractiveRectToRect:
        {
            self.interactiveAnimatedAnimationController.reverse=YES;
            return self.interactiveAnimatedAnimationController;
        }
            break;
            
            
        default:
            break;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    
    switch (self.animationControllerType) {
        case RectToRect:
        {
            return self.rectToRectAnimationController.interactionInProgress ? self.rectToRectAnimationController : nil;
        }
            break;
        case InteractiveRectToRect:
        {
            return self.interactiveAnimatedAnimationController;
        }
            break;
            
            
        default:
            break;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    
    switch (self.animationControllerType) {
        case RectToRect:
        {
            return self.rectToRectAnimationController.interactionInProgress ? self.rectToRectAnimationController : nil;
        }
            break;
        case InteractiveRectToRect:
        {
            
            return self.interactiveAnimatedAnimationController;
        }
            break;
            
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - Navigation Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if (operation == UINavigationControllerOperationPush) {
        switch (self.animationControllerType) {
            case RectToRect:
            {
                self.rectToRectAnimationController.reverse=NO;
                return self.rectToRectAnimationController;
            }
                break;
                
            case InteractiveRectToRect:
            {
                self.interactiveAnimatedAnimationController.reverse=NO;
                return self.interactiveAnimatedAnimationController;
            }
                break;
                
            default:
                break;
        }
    }
    else {
        
        switch (self.animationControllerType) {
            case RectToRect:
            {
                self.rectToRectAnimationController.reverse=YES;
                return self.rectToRectAnimationController;
            }
                break;
                
            case InteractiveRectToRect:
            {
                self.interactiveAnimatedAnimationController.reverse=YES;
                return self.interactiveAnimatedAnimationController;
            }
                break;
                
            default:
                break;
        }
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    
    switch (self.animationControllerType) {
        case RectToRect:
        {
            return self.rectToRectAnimationController.interactionInProgress ? self.rectToRectAnimationController : nil;
        }
            break;
            
        case InteractiveRectToRect:
        {
            return self.interactiveAnimatedAnimationController;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end
