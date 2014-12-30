//
//  PicOnlyLayout.m
//  CollectionViewCustomLayoutTest
//
//  Created by goguhuan on 12/26/14.
//  Copyright (c) 2014 goguhuan. All rights reserved.
//

#import "PicOnlyLayout.h"

@implementation PicOnlyLayout

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
    self.itemSize=CGSizeMake(249, 249);
    self.minimumInteritemSpacing=5;
    self.minimumLineSpacing=5;
    self.sectionInset=UIEdgeInsetsMake(0, 5, 5, 5);
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
