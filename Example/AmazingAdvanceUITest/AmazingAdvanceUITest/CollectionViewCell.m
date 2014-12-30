//
//  CollectionViewCell.m
//  AmazingAdvanceUITest
//
//  Created by goguhuan on 12/30/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.cellLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
        self.cellLabel.textColor=[UIColor redColor];
        [self.cellLabel setFont:[UIFont fontWithName:@"Arial" size:50.0f]];
        [self.contentView addSubview:self.cellLabel];
        
    }
    return self;
}

@end
