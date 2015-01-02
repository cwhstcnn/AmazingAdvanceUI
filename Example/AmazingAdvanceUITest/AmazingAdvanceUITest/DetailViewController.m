//
//  DetailViewController.m
//  AmazingUIAdvanceTest
//
//  Created by goguhuan on 12/29/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property UIView *blockView;

@property UIView *elseView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.frame=CGRectMake(0, 0, 768, 1024);
    
    UIView *dimmingView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    dimmingView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:dimmingView];
    
    UIView *blockView=[[UIView alloc] initWithFrame:CGRectMake(384-300, 400-300, 600, 600)];
    blockView.backgroundColor=[self randomColor];
    self.blockView=blockView;
    
    [self.view addSubview:self.blockView];
    
    
    UIView *elseView=[[UIView alloc] initWithFrame:CGRectMake(384-300, 850-150, 600, 300)];
    elseView.backgroundColor=[self randomColor];
    self.elseView=elseView;
    
    [self.view addSubview:self.elseView];
    
    UITapGestureRecognizer *tapGeture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.view addGestureRecognizer:tapGeture];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
//    [self.navigationController popViewControllerAnimated:YES];
    
    self.view.userInteractionEnabled=NO;
    [self dismissViewControllerAnimated:YES completion:^{
        self.view.userInteractionEnabled=YES;
    }];
}

- (UIColor *)randomColor
{
    CGFloat red=arc4random()%255;
    CGFloat green=arc4random()%255;
    CGFloat blue=arc4random()%255;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
