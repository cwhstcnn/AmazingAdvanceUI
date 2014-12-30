//
//  CardLayout.m
//  CollectionViewCustomLayoutTest
//
//  Created by goguhuan on 12/26/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "CardLayout.h"

@implementation CardLayout

- (instancetype)init
{
    self=[super init];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - Common Init
- (void)setUp
{
    CGFloat width=self.collectionView.bounds.size.width;
    CGFloat height=self.collectionView.bounds.size.height;
    if (width == 0 || width == 600 || width < height) {
        
        self.itemSize=CGSizeMake(768-10, 249);
        self.minimumLineSpacing=5;
        self.sectionInset=UIEdgeInsetsMake(0, 5, 5, 5);
        
    }
    else {
        
        self.itemSize=CGSizeMake(1024-10, 249);
        self.minimumLineSpacing=5;
        self.sectionInset=UIEdgeInsetsMake(0, 5, 5, 5);
        
    }
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self setUp];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    NSIndexPath *firstVisibleIndexPath=[self visibleIndexPathFirst];
    
    UICollectionViewLayoutAttributes *firstVisibleAttributes=[self layoutAttributesForItemAtIndexPath:firstVisibleIndexPath];
    CGFloat offsetY=firstVisibleAttributes.frame.origin.y;
    
    CGPoint targetPoint=CGPointMake(0, offsetY);
    return targetPoint;
}

#pragma mark - Private

- (NSIndexPath *)visibleIndexPathFirst
{
    NSArray *visibleIndexPaths=[self.collectionView indexPathsForVisibleItems];
    
    NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES];
    NSArray *sortedVisibleIndexPaths=[visibleIndexPaths sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSIndexPath *fisrtIndexPaht=[sortedVisibleIndexPaths objectAtIndex:0];
    return fisrtIndexPaht;
}

@end
