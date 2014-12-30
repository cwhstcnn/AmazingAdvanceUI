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

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,POPContextAnimationControllerDataSource,POPContextAnimationControllerDelegate,UINavigationControllerDelegate>

@property UICollectionView *collectionView;

@property POPRectToRectContextAnimationController *rectToRectAnimationController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.delegate=self;
    
    [self addSubCollectionView];
}

#pragma mark - Navigation Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if (operation == UINavigationControllerOperationPush) {
        self.rectToRectAnimationController.reverse=NO;
    }
    else {
        self.rectToRectAnimationController.reverse=YES;
    }
    
    return self.rectToRectAnimationController;
    
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    
    return self.rectToRectAnimationController.interactionInProgress ? self.rectToRectAnimationController : nil;
    return nil;
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
    
    POPRectToRectContextAnimationController *rectToRectContextAnimationController=[[POPRectToRectContextAnimationController alloc] init];
    rectToRectContextAnimationController.animationContextDataSource=self;
    [rectToRectContextAnimationController wireToView:detailVC.view viewController:detailVC];
    rectToRectContextAnimationController.animationContextDelegate=self;
    
    self.rectToRectAnimationController=rectToRectContextAnimationController;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
